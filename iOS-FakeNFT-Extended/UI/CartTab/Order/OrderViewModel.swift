//
//  OrderViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Denis on 25/01/2026.
//

import Foundation
import Observation
import Combine

@Observable
@MainActor
final class OrderViewModel {
    
    var orderItems: [NFTItem] = []
    var isLoading: Bool = true
    var loadError: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let cartRepo: CartRepository
    private let nftRepo: NFTsRepository
    private let profileRepo: ProfileRepository
    
    // MARK: - Computed Properties
    var isEmpty: Bool {
        orderItems.isEmpty
    }
    
    var totalPrice: Double {
        orderItems.reduce(Double(0)) { $0 + $1.price }
    }
    
    init(serviceAss: ServicesAssembly) {
        self.cartRepo = serviceAss.cartRepo
        self.nftRepo = serviceAss.nftRepo
        self.profileRepo = serviceAss.profileRepo
        
        cartRepo.updatePublisher.onCartUpdate { [weak self] cart in
            Task { await self?.loadOrder(forceRefresh: false) }
        }
        .store(in: &cancellables)
    }
    
    // MARK: - Public Methods
    func loadOrder(forceRefresh: Bool = false) async {
        isLoading = true
        loadError = nil
        defer { isLoading = false }
        
        do {
            let cart = try await cartRepo.getCart(forceRefresh: forceRefresh)
            orderItems = try await nftRepo.getNFTs(ids: cart.nfts, sortOrder: .byInput, forceRefresh: forceRefresh)
        } catch {
            debugPrint("Loading order failed: \(error.localizedDescription)")
        }
    }
    
    func dismissLoadError() {
        loadError = nil
    }
    
    
    func deleteItem(byId id: String) {
        Task {
            do {
                let updatedCartNFTIds = try await cartRepo.getCart(forceRefresh: false).nfts.filter { $0 != id }
                let _ = try await cartRepo.updateCart(.init(nfts: updatedCartNFTIds, id: "1"))
                await loadOrder(forceRefresh: true)
            } catch {
                loadError = networkErrorMessage(for: error)
                await loadOrder()
            }
        }
    }
    
    func clearCart() {
        orderItems = []
    }
    
    func performPayment(currencyId: String) async throws {
        guard !orderItems.isEmpty else { return }
        let paymentResult = try await cartRepo.payForOrder(currencyId: currencyId).success
        guard paymentResult else { throw NSError(domain: "PaymentError", code: 0, userInfo: nil) }
        let _ = try await cartRepo.purchaseSelectedNFTs(nftIds: orderItems.map(\.id))
        let _ = try await cartRepo.clearCart()
        let _ = try await profileRepo.getProfile(forceRefresh: true)
        orderItems.removeAll()
    }
    
    private func networkErrorMessage(for error: Error) -> String {
        (error as? URLError)?.localizedDescription ?? String(localized: "Error.network")
    }
}

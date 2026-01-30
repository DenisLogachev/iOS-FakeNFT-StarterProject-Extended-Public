//
//  OrderViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Denis on 25/01/2026.
//

import Foundation
import Observation

enum OrderSortOption {
    case byPrice
    case byRating
    case byName
}

@Observable
@MainActor
final class OrderViewModel {
    
    var orderItems: [OrderItem] = []
    var isLoading: Bool = false
    var loadError: String?
    private(set) var currentSortOption: OrderSortOption = .byPrice
    
    private let orderService: OrderService
    private let nftService: NftService
    
    // MARK: - Computed Properties
    var isEmpty: Bool {
        orderItems.isEmpty
    }
    
    var totalPrice: Decimal {
        orderItems.reduce(Decimal(0)) { $0 + $1.price }
    }
    
    init(orderService: OrderService, nftService: NftService) {
        self.orderService = orderService
        self.nftService = nftService
    }
    
    // MARK: - Public Methods
    func loadOrder() async {
        isLoading = true
        loadError = nil
        defer { isLoading = false }
        
        do {
            let order = try await orderService.loadOrder()
            guard !order.nfts.isEmpty else {
                orderItems = []
                return
            }
            let items: [OrderItem] = try await withThrowingTaskGroup(of: OrderItem.self) { group in
                for nftId in order.nfts {
                    group.addTask {
                        let nft = try await self.nftService.loadNft(id: nftId)
                        return OrderItem(nft: nft, price: Decimal(nft.price))
                    }
                }
                var collected: [OrderItem] = []
                for try await item in group {
                    collected.append(item)
                }
                return collected
            }
            orderItems = items
            applySort(by: currentSortOption)
        } catch {
            loadError = networkErrorMessage(for: error)
            orderItems = []
        }
    }
    
    func dismissLoadError() {
        loadError = nil
    }
    
    func applySort(by option: OrderSortOption) {
        currentSortOption = option
        switch option {
        case .byPrice:
            orderItems.sort { $0.price < $1.price }
        case .byRating:
            orderItems.sort { $0.nft.rating > $1.nft.rating }
        case .byName:
            orderItems.sort { $0.nft.name.localizedStandardCompare($1.nft.name) == .orderedAscending }
        }
    }
    
    func deleteItem(byId id: String) {
        orderItems = orderItems.filter { $0.id != id }
        Task {
            do {
                _ = try await orderService.updateOrder(nftIds: orderItems.map(\.id))
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
        let response = try await orderService.setCurrency(currencyId: currencyId)
        guard response.success else {
            throw NSError(domain: "Order", code: -1, userInfo: [
                NSLocalizedDescriptionKey: String(localized: "Payment.error.title")
            ])
        }
        _ = try? await orderService.updateOrder(nftIds: [])
    }
    
    private func networkErrorMessage(for error: Error) -> String {
        (error as? URLError)?.localizedDescription ?? String(localized: "Error.network")
    }
}

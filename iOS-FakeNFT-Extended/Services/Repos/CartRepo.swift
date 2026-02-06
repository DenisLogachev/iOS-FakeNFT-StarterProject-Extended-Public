//
//  CartRepo.swift
//  iOS-FakeNFT-Extended
//
//  Created by ANTON ZVERKOV on 05.02.2026.
//

import Foundation
import Combine

enum CartRepoError: Error {
    case getCartFailed
    case updateCartFailed(newCart: Cart)
    case paymentFailed(currencyId: String)
    case purchaseFailed(nftId: [String])
}

@MainActor
protocol CartRepository: AnyObject {
    var error: CartRepoError? { get }
    
    var cart: Cart? { get }
    var updatePublisher: AnyPublisher<RepoUpdate, Never> { get }
    
    func loadCartIfNeeded() async
    func getCart(forceRefresh: Bool) async throws -> Cart
    func updateCart(_ cart: Cart) async throws -> Cart
    func payForOrder(currencyId: String) async throws -> CheckoutResponse
    func purchaseSelectedNFTs(nftIds: [String]) async throws -> Cart
    func clearCart() async throws
    func retryAfter(error: CartRepoError) async throws
    func clearError()
}

@MainActor
@Observable
final class CartRepo: CartRepository {
    var error: CartRepoError?
    
    private let api: APIClientProtocol
    private let updateSubject = PassthroughSubject<RepoUpdate, Never>()
    
    var cart: Cart? {
        didSet { updateSubject.send(.cartUpdate(cart)) }
    }
    
    var updatePublisher: AnyPublisher<RepoUpdate, Never> {
        updateSubject.eraseToAnyPublisher()
    }
    
    init(api: APIClientProtocol) {
        self.api = api
        
        Task { await loadCartIfNeeded() }
    }
    
    /// Loads cart data if it is not already cached.
    ///
    /// - If the cart is already present in memory, does nothing.
    /// - If the cart is not cached, fetches it from the server.
    ///
    /// Errors are silently ignored.
    func loadCartIfNeeded() async {
            if cart == nil { cart = try? await getCart() }
    }

    /// Gets the current cart.
    ///
    /// - If the cart is already present in memory, returns the cached value.
    /// - If the cart is not cached or `forceRefresh` is `true`, fetches from server.
    ///
    /// - Parameter forceRefresh: Forces a new fetch from the server even if cached data exists.
    /// - Returns: User cart.
    func getCart(forceRefresh: Bool = false) async throws -> Cart {
        do {
            if let cart, !forceRefresh {
                return cart
            }
            
            let fresh = try await api.fetchCart()
            self.cart = fresh
            return fresh
        } catch {
            self.error = CartRepoError.getCartFailed
            throw error
        }
    }

    /// Updates cart contents.
    ///
    /// - Sends updated cart data to the server.
    /// - Replaces all user Cart content to sent data.
    /// - Updates cached cart with the server response.
    ///
    /// - Parameter cart: Cart data to update.
    /// - Returns: Updated cart.
    func updateCart(_ cart: Cart) async throws -> Cart {
        do {
            let updated = try await api.updateCart(cart)
            self.cart = updated
            return updated
        } catch {
            self.error = CartRepoError.updateCartFailed(newCart: cart)
            throw error
        }
    }
    
    /// Pays with provided currency ID.
    ///
    /// - Sends selected currency identifier to the server.
    /// - Does NOT update cached cart with the server response.
    /// - After receiving  payment confirmation, purchase request should be sent.
    /// - Cart should be cleared after.
    ///
    /// - Parameter currencyId: Identifier of currency payment to be made.
    /// - Returns: Response with payment result.
    func payForOrder(currencyId: String) async throws -> CheckoutResponse {
        do {
            let result = try await api.payForOrder(with: currencyId)
            return result
        }  catch {
            self.error = CartRepoError.paymentFailed(currencyId: currencyId)
            throw error
        }
    }

    /// Purchases selected NFTs from the cart.
    ///
    /// - Sends selected NFT identifiers to the server.
    /// - Updates cached cart with the server response.
    ///
    /// - Parameter nftIds: Identifiers of NFTs to purchase.
    /// - Returns: Updated cart after purchase.
    func purchaseSelectedNFTs(nftIds: [String]) async throws -> Cart {
        do {
            let result = try await api.purchaseSelectedNFTs(nftIds: nftIds)
            self.cart = result
            return result
        } catch {
            self.error = CartRepoError.purchaseFailed(nftId: nftIds)
            throw error
        }
    }
    
    /// Clears user cart.
    ///
    /// - Sends empty cart to the server.
    /// - Updates cached cart with the server response.
    func clearCart() async throws {
        let _ = try await updateCart(.init(nfts: [], id: "1"))
    }
    
    func retryAfter(error: CartRepoError) async throws {
        self.error = nil
        switch error {
        case .getCartFailed:
            let _ = try await getCart()
        case .updateCartFailed(let newCart):
            let _ = try await updateCart(newCart)
        case .paymentFailed(let currencyId):
            let _ = try await payForOrder(currencyId: currencyId)
        case .purchaseFailed(let nftId):
            let _ = try await purchaseSelectedNFTs(nftIds: nftId)
        }
    }
    
    func clearError() {
        self.error = nil
    }
}

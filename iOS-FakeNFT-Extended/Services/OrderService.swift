//
//  OrderService
//  iOS-FakeNFT-Extended
//
//  Created by Denis on 28/01/2026.
//

import Foundation

protocol OrderService {
    func loadOrder() async throws -> Order
    func updateOrder(nftIds: [String]) async throws -> PaymentResponse
    func setCurrency(currencyId: String) async throws -> PaymentResponse
}

@MainActor
final class OrderServiceImpl: OrderService {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadOrder() async throws -> Order {
        let request = GetOrderRequest()
        return try await networkClient.send(request: request)
    }
    
    func updateOrder(nftIds: [String]) async throws -> PaymentResponse {
        let request = PutOrderRequest(nftIds: nftIds)
        return try await networkClient.send(request: request)
    }
    
    func setCurrency(currencyId: String) async throws -> PaymentResponse {
        let request = SetOrderCurrencyRequest(currencyId: currencyId)
        return try await networkClient.send(request: request)
    }
}

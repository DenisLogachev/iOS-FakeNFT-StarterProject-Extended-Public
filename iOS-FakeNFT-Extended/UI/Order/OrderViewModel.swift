//
//  OrderViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Denis on 25/01/2026.
//

import Foundation
import Observation

@Observable
@MainActor
final class OrderViewModel {
    
    var orderItems: [OrderItem] = []
    var isLoading: Bool = false
    
    // MARK: - Computed Properties
    var isEmpty: Bool {
        orderItems.isEmpty
    }
    
    var totalPrice: Decimal {
        orderItems.reduce(Decimal(0)) { $0 + $1.price }
    }
    
    init() {
        loadMockData()
    }
    
    // MARK: - Private Methods
    private func loadMockData() {
        let mockData: [(id: String, price: String, imageIndices: [Int])] = [
            ("mock-nft-1", "1.5", [1, 2]),
            ("mock-nft-2", "2.3", [3, 4]),
            ("mock-nft-3", "0.8", [5, 6])
        ]
        
        orderItems = mockData.map { data in
            let images = data.imageIndices.map { index in
                URL(string: "https://picsum.photos/200/200?random=\(index)")!
            }
            return OrderItem(
                nft: Nft(id: data.id, images: images),
                price: Decimal(string: data.price)!
            )
        }
    }
    
    // MARK: - Public Methods
    func deleteItem(byId id: String) {
        orderItems = orderItems.filter { $0.id != id }
    }
    
    func clearCart() {
        orderItems = []
    }
}


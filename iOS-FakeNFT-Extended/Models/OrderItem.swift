//
//  OrderItem.swift
//  iOS-FakeNFT-Extended
//
//  Created by Denis on 25/01/2026.
//

import Foundation

typealias Price = Decimal

struct OrderItem: Identifiable, Sendable {
    let nft: Nft
    let price: Price
    
    var id: String {
        nft.id
    }
}

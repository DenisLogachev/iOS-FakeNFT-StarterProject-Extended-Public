//
//  Order.swift
//  iOS-FakeNFT-Extended
//
//  Created by Denis on 25/01/2026.
//

import Foundation

struct Order: Sendable, Codable {
    let id: String
    let nfts: [String]
    let currencyId: String?
}

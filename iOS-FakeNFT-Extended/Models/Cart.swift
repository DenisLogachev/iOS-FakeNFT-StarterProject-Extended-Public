//
//  Cart.swift
//  iOS-FakeNFT-Extended
//
//  Created by ANTON ZVERKOV on 06.02.2026.
//

import Foundation

import Foundation

struct Cart: Codable, Equatable {
    let nfts: [String]
    let id: String
}

#if DEBUG
extension Cart {
    static let mock: Cart = .init(nfts: ["b3907b86-37c4-4e15-95bc-7f8147a9a660", "de7c0518-6379-443b-a4be-81f5a7655f48"], id: "123")
}
#endif

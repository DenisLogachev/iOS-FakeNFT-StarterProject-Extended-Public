//
//  CheckoutResponse.swift
//  iOS-FakeNFT-Extended
//
//  Created by ANTON ZVERKOV on 06.02.2026.
//

import Foundation

struct CheckoutResponse: Codable {
    let success: Bool
    let orderId: String
    let id: String
}

#if DEBUG
extension CheckoutResponse {
    static let mock: CheckoutResponse = .init(success: true, orderId: "123", id: "123")
}
#endif


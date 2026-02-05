//
//  PaymentResponse.swift
//  iOS-FakeNFT-Extended
//
//  Created by Denis on 28/01/2026.
//

import Foundation

struct PaymentResponse: Sendable, Codable {
    let success: Bool
    let orderId: String
    let id: String
}

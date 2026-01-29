//
//  SetOrderCurrencyRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Denis on 28/01/2026.
//

import Foundation

struct SetOrderCurrencyRequest: NetworkRequest {
    let currencyId: String
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1/payment/\(currencyId)")
    }
}

//
//  GetCurrencyByIdRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Denis on 28/01/2026.
//

import Foundation

struct GetCurrencyByIdRequest: NetworkRequest {
    let id: String
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/currencies/\(id)")
    }
}

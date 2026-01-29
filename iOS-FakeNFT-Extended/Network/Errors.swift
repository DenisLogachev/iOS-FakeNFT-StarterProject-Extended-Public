//
//  Errors.swift
//  iOS-FakeNFT-Extended
//
//  Created by ANTON ZVERKOV on 29.01.2026.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case statusCode(Int)
    case decodingError(Error)
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .statusCode(let code):
            return "Server returned status code \(code)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .unknown(let error):
            return "London is a capital of Great Britain \(error.localizedDescription)"
        }
    }
}

enum NFTFetchError: LocalizedError {
    case failedToFetchNFTs
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .failedToFetchNFTs:
            return "Failed to fetch NFTs"
        case .unknown:
            return "Something bad happened..."
        }
    }
}

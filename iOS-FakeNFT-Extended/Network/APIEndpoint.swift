//
//  APIEndpoint.swift
//  iOS-FakeNFT-Extended
//
//  Created by ANTON ZVERKOV on 29.01.2026.
//

import Foundation

enum APIEndpoint {
    case collections
    case collection(id: String)
    case nfts
    case nft(id: String)
    
    var path: String {
        switch self {
        case .collections:
            return "/api/v1/collections"
        case .collection(let id):
            return "/api/v1/collections/\(id)"
        case .nfts:
            return "/api/v1/nft"
        case .nft(let id):
            return "/api/v1/nft/\(id)"
        }
    }
}

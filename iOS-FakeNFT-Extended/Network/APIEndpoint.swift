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
        case .collections: "/api/v1/collections"
        case .collection(let id): "/api/v1/collections/\(id)"
        case .nfts: "/api/v1/nft"
        case .nft(let id): "/api/v1/nft/\(id)"
        }
    }
}

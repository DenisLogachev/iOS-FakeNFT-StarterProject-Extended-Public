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
    case updateLikes(ids: [String])
    case getProfile
    case updateProfile(profile: Profile)
    case getCart
    case updateCart(ids: [String])
    case payForOrder(id: String)
    case checkOutCart(ids: [String])
    case currencies
    case currency(id: String)
    case users(sortBy: String?, page: Int?, size: Int?)
    case user(id: String)
    
    var path: String {
        switch self {
        case .collections: "/api/v1/collections"
        case .collection(let id): "/api/v1/collections/\(id)"
        case .nfts: "/api/v1/nft"
        case .nft(let id): "/api/v1/nft/\(id)"
        case .updateLikes, .getProfile, .updateProfile: "/api/v1/profile/1"
        case .getCart, .updateCart, .checkOutCart: "/api/v1/orders/1"
        case .payForOrder(id: let id): "/api/v1/orders/1/payment/\(id)"
        case .currencies: "/api/v1/currencies"
        case .currency(id: let id): "/api/v1/currencies/\(id)"
        case .users: "/api/v1/users"
        case .user(let id): "/api/v1/users/\(id)"
        }
    }
    
    var contentType: String {
        switch self {
        case .updateLikes, .updateProfile, .updateCart, .checkOutCart: "application/x-www-form-urlencoded"
        default: "application/json"
        }
    }
    
    var method: String {
        switch self {
        case .updateLikes, .updateProfile, .updateCart: "PUT"
        case .checkOutCart: "POST"
        default: "GET"
        }
    }
    
    var body: Data? {
        return switch self {
            
        case .updateLikes(ids: let ids):
            Data("likes=\(ids.isEmpty ? "null" : ids.joined(separator: ","))".utf8)
            
        case .updateProfile(profile: let profile):
            Data.from(params: profile.data)
            
        case .updateCart(ids: let ids):
            Data("nfts=\(ids.isEmpty ? "null" : ids.joined(separator: ","))".utf8)
            
        case .checkOutCart(ids: let ids):
            ids.isEmpty ? Data("nfts=null".utf8) : Data(ids.map { "nfts=\($0)" }.joined(separator: "&").utf8)
            
        default:
            nil
        }
    }
    var queryItems: [URLQueryItem] {
        switch self {
        case .users(let sortBy, let page, let size):
            var items: [URLQueryItem] = []
            if let sortBy { items.append(URLQueryItem(name: "sortBy", value: sortBy)) }
            if let page { items.append(URLQueryItem(name: "page", value: String(page))) }
            if let size { items.append(URLQueryItem(name: "size", value: String(size))) }
            return items
        default:
            return []
        }
    }
}



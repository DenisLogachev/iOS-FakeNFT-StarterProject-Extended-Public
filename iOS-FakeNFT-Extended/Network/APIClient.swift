//
//  APIClient.swift
//  iOS-FakeNFT-Extended
//
//  Created by ANTON ZVERKOV on 29.01.2026.
//

import Foundation

protocol APIClientProtocol {
    func fetchAllCollections() async throws -> [NFTCollection]
    func fetchCollection(id: String) async throws -> NFTCollection
    func fetchAllNFTs() async throws -> [NFTItem]
    func fetchNFT(id: String) async throws -> NFTItem
    func fetchProfile() async throws -> Profile
    func updateProfileLikes(likedNFTIds: [String]) async throws -> Profile
    func updateProfile(_ profile: Profile) async throws -> Profile
    func fetchCart() async throws -> Cart
    func updateCart(_ cart: Cart) async throws -> Cart
    func payForOrder(with currencyId: String) async throws -> CheckoutResponse
    func purchaseSelectedNFTs(nftIds: [String]) async throws -> Cart
    func fetchCurrencies() async throws -> [Currency]
    func fetchCurrency(id: String) async throws -> Currency
    func retryAfter<T: Decodable>(_ error: APIClientError) async throws -> T
}

actor APIClient: APIClientProtocol {
    private let baseURL: String
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(baseURL: String, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
        self.decoder = JSONDecoder()
    }
    
    private func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        guard let url = URL(string: baseURL + endpoint.path) else {
            throw APIClientError.invalidURL(endPoint: endpoint)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        request.setValue(endpoint.contentType, forHTTPHeaderField: "Content-Type")
        request.addValue(Secrets.apiToken, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        request.httpBody = endpoint.body
        
        let data: Data
        let response: URLResponse
        
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            debugPrint("❌ Failed to perform request, error: \(error), ➡️ endpoint: \(endpoint)")
            throw APIClientError.transport(error, endPoint: endpoint)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            debugPrint("❌ Invalid response from server, ➡️ endpoint: \(endpoint)")
            throw APIClientError.server(statusCode: -1, endPoint: endpoint, message: nil)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            let message = String(data: data, encoding: .utf8)
            debugPrint("❌ Invalid response from server: \(httpResponse.statusCode), \(message ?? "no message"), ➡️ endpoint: \(endpoint)")
            throw APIClientError.server(statusCode: httpResponse.statusCode, endPoint: endpoint, message: message)
        }
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            debugPrint("❌ Failed to decode: \(error), ➡️ endpoint: \(endpoint)")
            throw APIClientError.decoding(error, endPoint: endpoint)
        }
    }
    
    func retryAfter<T: Decodable>(_ error: APIClientError) async throws -> T {
        let endpoint: APIEndpoint = switch error {
        case .invalidURL(let endPoint): endPoint
        case .transport(_, let endPoint): endPoint
        case .server(_, let endPoint, _): endPoint
        case .decoding(_, let endPoint): endPoint
        }
        return try await request(endpoint)
    }
    
    func fetchAllCollections() async throws -> [NFTCollection] {
        try await request(.collections)
    }
    
    func fetchCollection(id: String) async throws -> NFTCollection {
        try await request(.collection(id: id))
    }
    
    func fetchAllNFTs() async throws -> [NFTItem] {
        try await request(.nfts)
    }
    
    func fetchNFT(id: String) async throws -> NFTItem {
        try await request(.nft(id: id))
    }
    
    func fetchProfile() async throws -> Profile {
        try await request(.getProfile)
    }
    
    func updateProfileLikes(likedNFTIds: [String]) async throws -> Profile {
        try await request(.updateLikes(ids: likedNFTIds))
    }
    
    func updateProfile(_ profile: Profile) async throws -> Profile {
        try await request(.updateProfile(profile: profile))
    }
    
    func fetchCart() async throws -> Cart {
        try await request(.getCart)
    }
    
    func updateCart(_ cart: Cart) async throws -> Cart {
        try await request(.updateCart(ids: cart.nfts))
    }
    
    func payForOrder(with currencyId: String) async throws -> CheckoutResponse {
        try await request(.payForOrder(id: currencyId))
    }
    
    func purchaseSelectedNFTs(nftIds: [String]) async throws -> Cart {
        try await request(.checkOutCart(ids: nftIds))
    }
    
    func fetchCurrencies() async throws -> [Currency] {
        try await request(.currencies)
    }
    
    func fetchCurrency(id: String) async throws -> Currency {
        try await request(.currency(id: id))
    }
}

#if DEBUG
final class MockAPIClient: APIClientProtocol {
    private let delay: UInt64
    
    init(delay: UInt64 = 500_000_000) {
        self.delay = delay
    }
    
    func retryAfter<T: Decodable>(_ error: APIClientError) async throws -> T {
        debugPrint("Not retrying in mock setup")
        throw error
    }
    
    func fetchAllCollections() async throws -> [NFTCollection] {
        try await Task.sleep(nanoseconds: delay)
        return NFTCollection.mockCollections
    }
    
    func fetchCollection(id: String) async throws -> NFTCollection {
        try await Task.sleep(nanoseconds: delay)
        guard let collection = NFTCollection.mockCollections.first(where: { $0.id == id }) else {
            throw NetworkError.statusCode(404)
        }
        return collection
    }
    
    func fetchAllNFTs() async throws -> [NFTItem] {
        try await Task.sleep(nanoseconds: delay)
        return NFTItem.mockNFTs
    }
    
    func fetchNFT(id: String) async throws -> NFTItem {
        try await Task.sleep(nanoseconds: delay)
        guard let nft = NFTItem.mockNFTs.first(where: { $0.id == id }) else {
            throw NetworkError.statusCode(404)
        }
        return nft
    }
    
    func fetchProfile() async throws -> Profile {
        try await Task.sleep(nanoseconds: delay)
        return .mock
    }
    
    func updateProfileLikes(likedNFTIds: [String]) async throws -> Profile {
        try await Task.sleep(nanoseconds: delay)
        return .mock
    }
    
    func updateProfile(_ profile: Profile) async throws -> Profile {
        try await Task.sleep(nanoseconds: delay)
        return .mock
    }
    
    func fetchCart() async throws -> Cart {
        try await Task.sleep(nanoseconds: delay)
        return .mock
    }
    
    func updateCart(_ cart: Cart) async throws -> Cart {
        try await Task.sleep(nanoseconds: delay)
        return .mock
    }
    
    func payForOrder(with currencyId: String) async throws -> CheckoutResponse {
        try await Task.sleep(nanoseconds: delay)
        return .mock
    }
    
    func purchaseSelectedNFTs(nftIds: [String]) async throws -> Cart {
        try await Task.sleep(nanoseconds: delay)
        return .mock
    }
    
    func fetchCurrencies() async throws -> [Currency] {
        try await Task.sleep(nanoseconds: delay)
        return [.mock]
    }
    
    func fetchCurrency(id: String) async throws -> Currency {
        try await Task.sleep(nanoseconds: delay)
        return .mock
    }
    
}
#endif


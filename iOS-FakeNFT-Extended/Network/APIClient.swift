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
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Secrets.apiToken, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.statusCode(httpResponse.statusCode)
        }
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
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
}

#if DEBUG
final class MockAPIClient: APIClientProtocol {
    private let delay: UInt64
    
    init(delay: UInt64 = 500_000_000) {
        self.delay = delay
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
}
#endif


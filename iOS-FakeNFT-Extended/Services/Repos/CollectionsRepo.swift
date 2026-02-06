//
//  CollectionsRepo.swift
//  iOS-FakeNFT-Extended
//
//  Created by ANTON ZVERKOV on 05.02.2026.
//

import Foundation
import Combine

enum CollectionsRepoError: Error {
    case getAllCollectionsFailed
    case getCollectionByIdFailed(id: String)
}

@MainActor
protocol CollectionsRepository: AnyObject {
    var error: CollectionsRepoError? { get }
    
    var collections: [NFTCollection]? { get }
    var collectionsById: [String: NFTCollection] { get }
    var updatePublisher: AnyPublisher<RepoUpdate, Never> { get }
    
    func getAllCollections(forceRefresh: Bool) async throws -> [NFTCollection]
    func getCollection( id: String, forceRefresh: Bool) async throws -> NFTCollection
    func retryAfter(error: CollectionsRepoError) async throws
    func clearError()
}

@MainActor
@Observable
final class CollectionsRepo: CollectionsRepository {
    var error: CollectionsRepoError?
    
    private let api: APIClientProtocol
    private let updateSubject = PassthroughSubject<RepoUpdate, Never>()
    
    var collections: [NFTCollection]? {
        didSet { updateSubject.send(.collectionsUpdate(collections)) }
    }
    
    var collectionsById: [String: NFTCollection] = [:] {
        didSet { updateSubject.send(.collectionsById(collectionsById)) }
    }
    
    var updatePublisher: AnyPublisher<RepoUpdate, Never> {
        updateSubject.eraseToAnyPublisher()
    }
    
    init(api: APIClientProtocol) {
        self.api = api
        
        Task { await loadCollectionsIfNeeded() }
    }
    
    /// Loads collections if it is not already cached.
    ///
    /// - If the collections are already present in memory, does nothing.
    /// - If the collections are not cached, fetches it from the server.
    ///
    /// Errors are silently ignored.
    func loadCollectionsIfNeeded() async {
        if collections == nil { collections = try? await getAllCollections() }
    }
    
    /// Gets all NFT collections.
    ///
    /// - If collections are already present in memory, returns cached values.
    /// - If collections are not cached or `forceRefresh` is `true`, fetches from server.
    ///
    /// - Parameter forceRefresh: Forces a new fetch from the server even if cached data exists.
    /// - Returns: All NFT collections.
    func getAllCollections(forceRefresh: Bool = false) async throws -> [NFTCollection] {
        do {
            if let collections, !forceRefresh {
                return collections
            }
            
            let fresh = try await api.fetchAllCollections()
            self.collections = fresh
            self.collectionsById = Dictionary(
                uniqueKeysWithValues: fresh.map { ($0.id, $0) }
            )
            return fresh
        } catch {
            self.error = .getAllCollectionsFailed
            throw error
        }
    }

    /// Gets an NFT collection by its identifier.
    ///
    /// - If the collection is already present in memory, returns the cached value.
    /// - If the collection is not cached or `forceRefresh` is `true`, fetches from server.
    ///
    /// - Parameters:
    ///   - id: Identifier of the NFT collection.
    ///   - forceRefresh: Forces a new fetch from the server even if cached data exists.
    /// - Returns: NFT collection with the specified identifier.
    func getCollection( id: String, forceRefresh: Bool = false) async throws -> NFTCollection {
        do {
            if let cached = collectionsById[id], !forceRefresh {
                return cached
            }
            
            let fresh = try await api.fetchCollection(id: id)
            collectionsById[id] = fresh
            return fresh
        } catch {
            self.error = .getCollectionByIdFailed(id: id)
            throw error
        }

    }
    
    func retryAfter(error: CollectionsRepoError) async throws {
        self.error = nil
        switch error {
        case .getAllCollectionsFailed:
            let _ = try await getAllCollections()
        case .getCollectionByIdFailed(let id):
            let _ = try await getCollection(id: id)
        }
    }
    
    func clearError() {
        self.error = nil
    }
}

//
//  NFTRepo.swift
//  iOS-FakeNFT-Extended
//
//  Created by ANTON ZVERKOV on 05.02.2026.
//

import Foundation
import Combine

enum NFTRepoError: Error {
    case getAllNFTsFailed
    case getNFTByIdFailed(id: String)
    case getMultipleNFTsByIdsFailed(ids: [String])
}

@MainActor
protocol NFTsRepository: AnyObject {
    var error: NFTRepoError? { get }
    
    var nfts: [NFTItem]? { get }
    var nftsById: [String: NFTItem] { get }
    var updatePublisher: AnyPublisher<RepoUpdate, Never> { get }
    
    func getNFTs(ids: [String], sortOrder: NFTSortOrder, forceRefresh: Bool) async throws -> [NFTItem]
    func getAllNFTs(forceRefresh: Bool) async throws -> [NFTItem]
    func getNFT(id: String, forceRefresh: Bool) async throws -> NFTItem
    func retryAfter(error: NFTRepoError) async throws
    func clearError()
}

@MainActor
@Observable
final class NFTRepo: NFTsRepository {
    var error: NFTRepoError?
    
    private let api: APIClientProtocol
    private let updateSubject = PassthroughSubject<RepoUpdate, Never>()
    
    var nfts: [NFTItem]? {
        didSet { updateSubject.send(.nftsUpdate(nfts)) }
    }
    
    var nftsById: [String: NFTItem] = [:] {
        didSet { updateSubject.send(.nftsById(nftsById)) }
    }
    
    var updatePublisher: AnyPublisher<RepoUpdate, Never> {
        updateSubject.eraseToAnyPublisher()
    }
    
    init(api: APIClientProtocol) {
        self.api = api
    }
    
    /// Gets multiple NFT items from array of IDs.
    ///
    /// - If NFTs are already present in memory, returns cached values.
    /// - If NFTs are not cached or `forceRefresh` is `true`, fetches from server.
    ///
    /// - Parameter ids: Array of NFT identifiers.
    /// - Parameter sortOrder: Sort order of returned NFTs.
    /// - Parameter forceRefresh: Forces a new fetch from the server even if cached data exists.
    /// - Returns: NFTs with the specified identifiers.
    func getNFTs(ids: [String], sortOrder: NFTSortOrder = .byInput, forceRefresh: Bool = false) async throws -> [NFTItem] {
        do {
            return try await withThrowingTaskGroup(of: (Int, NFTItem).self) { group in
                for (index, id) in ids.enumerated() {
                    group.addTask {
                        let nft = try await self.getNFT(id: id, forceRefresh: forceRefresh)
                        return (index, nft)
                    }
                }
                
                var buffer = Array<NFTItem?>(repeating: nil, count: ids.count)
                
                for try await (index, nft) in group { buffer[index] = nft }
                let orderedByInput = buffer.compactMap { $0 }
                
                return sortOrder == .byInput ? orderedByInput : orderedByInput.sorted(by: sortOrder)
            }
        } catch {
            self.error = NFTRepoError.getMultipleNFTsByIdsFailed(ids: ids)
            throw error
        }
    }

    /// Gets all NFT items.
    ///
    /// - If NFTs are already present in memory, returns cached values.
    /// - If NFTs are not cached or `forceRefresh` is `true`, fetches from server.
    ///
    /// - Parameter forceRefresh: Forces a new fetch from the server even if cached data exists.
    /// - Returns: All NFT items.
    func getAllNFTs(forceRefresh: Bool = false) async throws -> [NFTItem] {
        do {
            if let nfts, !forceRefresh {
                return nfts
            }
            
            let fresh = try await api.fetchAllNFTs()
            self.nfts = fresh
            self.nftsById = Dictionary(
                uniqueKeysWithValues: fresh.map { ($0.id, $0) }
            )
            return fresh
        } catch {
            self.error = NFTRepoError.getAllNFTsFailed
            throw error
        }
    }

    /// Gets single NFT item by its identifier.
    ///
    /// - If the NFT is already present in memory, returns the cached value.
    /// - If the NFT is not cached or `forceRefresh` is `true`, fetches from server.
    ///
    /// - Parameters:
    ///   - id: Identifier of the NFT.
    ///   - forceRefresh: Forces a new fetch from the server even if cached data exists.
    /// - Returns: NFT item with the specified identifier.
    func getNFT(id: String, forceRefresh: Bool = false) async throws -> NFTItem {
        do {
            if let cached = nftsById[id], !forceRefresh {
                return cached
            }
            
            let fresh = try await api.fetchNFT(id: id)
            nftsById[id] = fresh
            return fresh
        } catch {
            self.error = NFTRepoError.getNFTByIdFailed(id: id)
            throw error
        }
    }
    
    func retryAfter(error: NFTRepoError) async throws {
        self.error = nil
        switch error {
        case .getAllNFTsFailed:
            let _ = try await getAllNFTs(forceRefresh: true)
        case .getNFTByIdFailed(let id):
            let _ = try await getNFT(id: id, forceRefresh: true)
        case .getMultipleNFTsByIdsFailed(let ids):
            let _ = try await getNFTs(ids: ids, forceRefresh: true)
        }
    }
    
    func clearError() {
        self.error = nil
    }
}


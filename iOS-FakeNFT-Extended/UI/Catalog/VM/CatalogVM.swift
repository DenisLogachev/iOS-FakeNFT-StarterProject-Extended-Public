//
//  CatalogVM.swift
//  iOS-FakeNFT-Extended
//
//  Created by ANTON ZVERKOV on 28.01.2026.
//

import SwiftUI

@MainActor
@Observable
final class CatalogVM {
    var collections: [NFTCollection] = []
    var collectionCovers: [String: Image] = [:]
    
    var isRefreshingNFTs: Bool = false
    var isLoading: Bool = false
    
    var showError = false
    var errorMessage = ""
    
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
        
        Task { await loadData() }
    }
    
    func sortedCollections(by sortOption: SortOption) -> [NFTCollection] {
        switch sortOption {
        case .byName:
            collections.sorted { $0.name < $1.name }
        case .byNFTCount:
            collections.sorted { $0.uniqueNfts.count > $1.uniqueNfts.count }
        }
    }
    
    func loadCollectionsCoverImages(for collections: [NFTCollection]) async {
        await withThrowingTaskGroup(of: Void.self) { group in
            for collection in collections {
                group.addTask {
                    guard let url = URL(string: collection.cover) else {
                        throw NetworkError.invalidURL
                    }
                    
                    let (data, _) = try await URLSession.shared.data(from: url)
                    
                    if let uiImage = UIImage(data: data) {
                        await MainActor.run { self.collectionCovers[collection.id] = Image(uiImage: uiImage) }
                    } else {
                        throw NetworkError.invalidURL
                    }
                }
            }
        }
    }
    
    func refreshNFTs(for collection: NFTCollection) async throws -> [String: NFTItem?] {
        isRefreshingNFTs = true
        defer { isRefreshingNFTs = false }
        return try await loadNFTs(for: collection)
    }
    
    func loadNFTs(for collection: NFTCollection) async throws -> [String: NFTItem?] {
        try await withThrowingTaskGroup(of: NFTItem?.self) { group in
            
            var fetchedNFTs: [String : NFTItem] = [:]
            fetchedNFTs.reserveCapacity(collection.nfts.count)
            
            for nftId in collection.nfts {
                group.addTask {
                    try? await self.apiClient.fetchNFT(id: nftId)
                }
            }
            
            for try await nft in group {
                if let nft {
                    fetchedNFTs[nft.id] = nft
                }
            }
            
            if fetchedNFTs.isEmpty {
                throw NFTFetchError.failedToFetchNFTs
            }
            
            return fetchedNFTs
        }
    }

    func loadData() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            collections = try await apiClient.fetchAllCollections()
            await loadCollectionsCoverImages(for: collections)
        } catch {
            handleError(error)
        }
    }
    
    func tryAgain() async {
        errorMessage = ""
        showError = false
        await loadData()
    }
    
    func refreshData() async {
        await loadData()
    }
    
    private func handleError(_ error: Error) {
        errorMessage = error.localizedDescription
        showError = true
    }
}

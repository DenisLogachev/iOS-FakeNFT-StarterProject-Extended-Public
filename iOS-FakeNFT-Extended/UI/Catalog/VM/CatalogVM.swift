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
    
    //TODO: let apiClient = ...
    
    init() {
        Task { await loadData() }
    }
    
    //TODO: add collection cover fetching
    func loadCollectionsCoverImages(for collections: [NFTCollection]) async {
        await withThrowingTaskGroup(of: Void.self) { group in
            for collection in collections {
                group.addTask {
                    await MainActor.run { self.collectionCovers[collection.id] = Image(.peachGroup) }
                }
            }
        }
    }
    
    func refreshNFTs(for collection: NFTCollection) async throws -> [String: NFTItem?] {
        isRefreshingNFTs = true
        defer { isRefreshingNFTs = false }
        return try await loadNFTs(for: collection)
    }
    
    //TODO: add concurrent NFTItems fetching
    func loadNFTs(for collection: NFTCollection) async throws -> [String: NFTItem?] {
        let mocks = NFTItem.mockNFTs
        return mocks.reduce(into: [:]) { result, mock in
            result[mock.id] = mock
        }
    }
    
    //TODO: 1) add collections fetching
    //TODO: 2) add collections covers fetching (for passing to collectionView without refetching)
    func loadData() async {
        isLoading = true
        defer { isLoading = false }
        
        collections = NFTCollection.mockCollections
        await loadCollectionsCoverImages(for: collections)
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

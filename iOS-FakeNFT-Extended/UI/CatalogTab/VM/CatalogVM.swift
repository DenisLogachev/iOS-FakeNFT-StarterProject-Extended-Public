//
//  CatalogVM.swift
//  iOS-FakeNFT-Extended
//
//  Created by ANTON ZVERKOV on 28.01.2026.
//

import SwiftUI
import Combine

enum LikeState {
    case unknown
    case liked
    case notLiked
}

enum CartState {
    case unknown
    case added
    case notAdded
}

@MainActor
@Observable
final class CatalogVM {
    var likingTask: Task<Profile, Error>?
    var cartTask: Task<Cart, Error>?
    
    var collections: [NFTCollection] = []
    var collectionCovers: [String: Image] = [:]
    
    var pendingCartUpdates: Set<String> = []
    var pendingLikeRequests: Set<String> = []
    
    var isRefreshingNFTs: Bool = false
    var isLoading: Bool = true
    
    var showError = false
    var errorMessage = ""
    
    var refreshId = UUID()
    
    private var cancellables = Set<AnyCancellable>()
    
    private let collectionsRepo: CollectionsRepository
    private let profileRepo: ProfileRepository
    private let cartRepo: CartRepository
    private let nftRepo: NFTsRepository
    
    init(serviceAss: ServicesAssembly) {
        self.collectionsRepo = serviceAss.collectionsRepo
        self.profileRepo = serviceAss.profileRepo
        self.cartRepo = serviceAss.cartRepo
        self.nftRepo = serviceAss.nftRepo
        
        collectionsRepo.updatePublisher.onCollectionsUpdate { [weak self] collections in
            Task { await self?.updateCollections(with: collections) }
        }
        .store(in: &cancellables)
    }
    
    func nftLikeState(_ nft: NFTItem) -> LikeState {
        if pendingLikeRequests.contains(nft.id) {
            .unknown
        } else if let likedNFTs = profileRepo.profile?.likes {
            likedNFTs.contains(nft.id) ? .liked : .notLiked
        } else {
            .unknown
        }
    }
    
    func nftCartState(_ nft: NFTItem) -> CartState {
        if pendingCartUpdates.contains(nft.id) {
            .unknown
        } else if let cartContents = cartRepo.cart?.nfts {
            cartContents.contains(nft.id) ? .added : .notAdded
        } else {
            .unknown
        }
    }
    
    @discardableResult
    func changeCartContents(for nftIDs: Set<String>, in cart: Cart) async throws -> Cart {
        let currentCartContents = Set(cart.nfts)
        let nftsToPost = currentCartContents.symmetricDifference(nftIDs)
        
        if let existingTask = cartTask {
            existingTask.cancel()
            cartTask = nil
        }
        
        let newTask = Task {
            try await cartRepo.updateCart(Cart(nfts: Array(nftsToPost), id: cart.id))
        }
        
        cartTask = newTask
        return try await newTask.value
    }
    
    @discardableResult
    func changeLikes(for nftIDs: Set<String>, in profile: Profile) async throws -> Profile {
        let currentLikes = Set(profile.likes ?? [])
        let likesToPost = currentLikes.symmetricDifference(nftIDs)
        
        if let existingTask = likingTask {
            existingTask.cancel()
            likingTask = nil
        }
        
        let newTask = Task {
            try await profileRepo.updateProfileLikes(likesToPost.map(\.self))
        }
        
        likingTask = newTask
        return try await newTask.value
    }
    
    func changeCart(for nft: NFTItem) async {
        
        pendingCartUpdates.insert(nft.id)
        defer { pendingCartUpdates.removeAll() }
        
        do {
            let cart = try await cartRepo.getCart(forceRefresh: false)
            try await changeCartContents(for: pendingCartUpdates, in: cart)
        } catch {
            handleError(error)
        }
    }
    
    func changeLike(for nft: NFTItem) async {
        
        pendingLikeRequests.insert(nft.id)
        defer { pendingLikeRequests.removeAll() }
        
        do {
            let profile = try await profileRepo.getProfile(forceRefresh: false)
            try await changeLikes(for: pendingLikeRequests, in: profile)
        } catch {
            handleError(error)
        }
    }
    
    func sortedCollections(by sortOption: CollectionSortOrder) -> [NFTCollection] {
        switch sortOption {
        case .byName:
            collections.sorted { $0.name < $1.name }
        case .byNFTCount:
            collections.sorted { $0.uniqueNfts.count > $1.uniqueNfts.count }
        }
    }
    
    func loadCollectionsCoverImages(for collections: [NFTCollection]) async throws {
        try await withThrowingTaskGroup(of: Void.self) { group in
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
            try await group.waitForAll()
        }
    }
    
    func refreshNFTs(for collection: NFTCollection) async throws -> [String: NFTItem?] {
        isRefreshingNFTs = true
        defer { isRefreshingNFTs = false }
        refreshId = UUID()
        return try await loadNFTs(for: collection)
    }
    
    func loadNFTs(for collection: NFTCollection) async throws -> [String: NFTItem?] {
        let ids = collection.uniqueNfts
        guard !ids.isEmpty else { return [:] }
        
        let nfts = try await nftRepo.getNFTs(ids: ids, sortOrder: .byName, forceRefresh: false)
        if nfts.isEmpty { throw NFTFetchError.failedToFetchNFTs }
        
        return Dictionary(uniqueKeysWithValues: nfts.map { ($0.id, $0) })
    }

    func loadData() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            collections = try await collectionsRepo.getAllCollections(forceRefresh: false)
            try await loadCollectionsCoverImages(for: collections)
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
    
    func handleError(_ error: Error) {
        errorMessage = error.localizedDescription
        showError = true
    }
    
    func updateCollections(with newCollections: [NFTCollection]?) async {
        guard let newCollections, self.collections != newCollections else { return }
        await loadData()
    }
}

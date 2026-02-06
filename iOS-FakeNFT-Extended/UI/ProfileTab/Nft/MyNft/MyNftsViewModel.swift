//
//  MyNftsViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Aida Zhdanova on 30.01.2026.
//

import Foundation

enum MyNftsState: Sendable {
    case idle
    case loaded([NFTItem])
    case empty
}

@Observable
@MainActor
final class MyNftsViewModel {
    private let profileRepo: ProfileRepository
    private let nftRepo: NFTsRepository
    private var profile: Profile

    private(set) var state: MyNftsState = .idle
    private(set) var isLoading: Bool = false
    private var likeUpdatingIds: Set<String> = []
    private var isLoadingTaskRunning = false

    private var allNfts: [NFTItem] = []

    init(serviceAssembly: ServicesAssembly, profile: Profile) {
        self.profileRepo = serviceAssembly.profileRepo
        self.nftRepo = serviceAssembly.nftRepo
        self.profile = profile
    }

    func load() async {
        await loadInternal(forceRefresh: false)
    }

    func refresh() async {
        await loadInternal(forceRefresh: true)
    }

    func toggleLike(id: String) {
        Task { [weak self] in
            do {
                try await self?.toggleLikeAsync(id: id)
            } catch {
                debugPrint("Like toggle error: \(error)")
            }
        }
    }

    func isLiked(id: String) -> Bool {
        profile.likes?.contains(id) ?? false
    }

    func isLikeUpdating(id: String) -> Bool {
        likeUpdatingIds.contains(id)
    }

    private func loadInternal(forceRefresh: Bool) async {
        do {
            guard !isLoadingTaskRunning else { return }
            isLoadingTaskRunning = true
            defer { isLoadingTaskRunning = false }
            
            isLoading = true
            defer { isLoading = false }
            
            if let myNFTIds = profile.nfts, myNFTIds.count > 0 {
                allNfts = try await nftRepo.getNFTs(ids: myNFTIds, sortOrder: .byInput, forceRefresh: forceRefresh)
                state = allNfts.isEmpty ? .empty : .loaded(allNfts)
            } else {
                allNfts = []
                state = .empty
            }
        } catch {
            debugPrint("myNFTs load error: \(error)")
            allNfts = []
            state = .empty
        }
    }

    private func toggleLikeAsync(id: String) async throws {
        guard !likeUpdatingIds.contains(id) else { return }
        likeUpdatingIds.insert(id)
        defer { likeUpdatingIds.remove(id) }
        
        profile = try await profileRepo.toggleLikeNFT(nftId: id)
    }
}

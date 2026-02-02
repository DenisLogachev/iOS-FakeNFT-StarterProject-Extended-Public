//
//  FavouriteNftsViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Aida Zhdanova on 02.02.2026.
//

import Foundation

enum FavouriteNftsState: Sendable {
    case idle
    case loaded([Nft])
    case empty
}

@Observable
@MainActor
final class FavouriteNftsViewModel {
    private let nftService: NftService
    private let likesService: NftLikesService
    private let profileId: Int

    private(set) var state: FavouriteNftsState = .idle
    private(set) var isLoading: Bool = false
    private(set) var isLikeUpdating: Bool = false

    private var likedIds: [String] = []
    private var nftsById: [String: Nft] = [:]
    private var isLoadingTaskRunning = false

    init(nftService: NftService, likesService: NftLikesService, profileId: Int) {
        self.nftService = nftService
        self.likesService = likesService
        self.profileId = profileId
    }

    func load() async {
        guard !isLoadingTaskRunning else { return }
        isLoadingTaskRunning = true
        defer { isLoadingTaskRunning = false }

        isLoading = true
        defer { isLoading = false }

        let likes = await likesService.getLikedNftIds(profileId: profileId)
        likedIds = likes

        guard !likes.isEmpty else {
            nftsById = [:]
            state = .empty
            return
        }

        let loaded = await loadNfts(ids: likes)
        nftsById = Dictionary(uniqueKeysWithValues: loaded.map { ($0.id, $0) })

        let ordered = likes.compactMap { nftsById[$0] }
        state = ordered.isEmpty ? .empty : .loaded(ordered)
    }

    func isLiked(id: String) -> Bool {
        likedIds.contains(id)
    }

    func toggleLike(id: String) {
        Task { [weak self] in
            await self?.toggleLikeAsync(id: id)
        }
    }

    private func toggleLikeAsync(id: String) async {
        guard !isLikeUpdating else { return }
        isLikeUpdating = true
        defer { isLikeUpdating = false }

        guard likedIds.contains(id) else { return }

        let updatedLikes = await likesService.removeLike(profileId: profileId, nftId: id)
        guard let updatedLikes else { return }

        likedIds = updatedLikes
        nftsById[id] = nil

        let ordered = likedIds.compactMap { nftsById[$0] }
        state = ordered.isEmpty ? .empty : .loaded(ordered)
    }

    private func loadNfts(ids: [String]) async -> [Nft] {
        await withTaskGroup(of: Nft?.self) { group in
            for id in ids {
                group.addTask { [nftService] in
                    do { return try await nftService.loadNft(id: id) }
                    catch { return nil }
                }
            }

            var result: [Nft] = []
            result.reserveCapacity(ids.count)

            for await nft in group {
                if let nft { result.append(nft) }
            }
            return result
        }
    }
}

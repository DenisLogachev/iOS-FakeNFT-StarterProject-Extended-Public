//
//  MyNftsViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Aida Zhdanova on 30.01.2026.
//

import Foundation

enum MyNftsState: Sendable {
    case idle
    case loaded([Nft])
    case empty
}

@Observable
@MainActor
final class MyNftsViewModel {
    private let nftService: NftService
    private let myNftsStore: MyNftsStore
    private let profileService: ProfileService
    private let profileId: Int

    private(set) var state: MyNftsState = .idle
    private(set) var isLoading: Bool = false
    private(set) var isLikeUpdating: Bool = false

    private var likedIds: Set<String> = []
    private var isLoadingTaskRunning = false

    private var allNfts: [Nft] = []
    private(set) var sortType: MyNftsSortType = .byName

    init(
        nftService: NftService,
        myNftsStore: MyNftsStore,
        profileService: ProfileService,
        profileId: Int
    ) {
        self.nftService = nftService
        self.myNftsStore = myNftsStore
        self.profileService = profileService
        self.profileId = profileId
    }

    func load() async {
        guard !isLoadingTaskRunning else { return }
        isLoadingTaskRunning = true
        defer { isLoadingTaskRunning = false }

        isLoading = true
        defer { isLoading = false }

        let likes = await profileService.getProfileLikes(id: profileId)
        likedIds = Set(likes)

        let ids = await myNftsStore.getMyNftIds()
        guard !ids.isEmpty else {
            state = .empty
            return
        }

        let loadedNfts = await loadNfts(ids: ids)

        guard !loadedNfts.isEmpty else {
            state = .empty
            return
        }

        let ordered = ids.compactMap { id in loadedNfts.first(where: { $0.id == id }) }

        allNfts = ordered
        applySorting()
    }

    func setSortType(_ newType: MyNftsSortType) {
        guard sortType != newType else { return }
        sortType = newType
        applySorting()
    }

    func toggleLike(id: String) {
        Task { [weak self] in
            await self?.toggleLikeAsync(id: id)
        }
    }

    func isLiked(id: String) -> Bool {
        likedIds.contains(id)
    }

    private func applySorting() {
        guard !allNfts.isEmpty else {
            state = .empty
            return
        }

        let sorted = sort(allNfts, by: sortType)
        state = .loaded(sorted)
    }

    private func sort(_ nfts: [Nft], by type: MyNftsSortType) -> [Nft] {
        switch type {
        case .byName:
            return nfts.sorted { leftNft, rightNft in
                let leftName = (leftNft.name ?? "")
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                let rightName = (rightNft.name ?? "")
                    .trimmingCharacters(in: .whitespacesAndNewlines)

                if leftName.isEmpty { return false }
                if rightName.isEmpty { return true }

                return leftName.localizedCaseInsensitiveCompare(rightName) == .orderedAscending
            }

        case .byPrice:
            return nfts.sorted { leftNft, rightNft in
                switch (leftNft.price, rightNft.price) {
                case let (leftPrice?, rightPrice?):
                    return leftPrice < rightPrice

                case (nil, _?):
                    return false

                case (_?, nil):
                    return true

                case (nil, nil):
                    return false
                }
            }

        case .byRating:
            return nfts.sorted { leftNft, rightNft in
                switch (leftNft.rating, rightNft.rating) {
                case let (leftRating?, rightRating?):
                    return leftRating > rightRating

                case (nil, _?):
                    return false

                case (_?, nil):
                    return true

                case (nil, nil):
                    return false
                }
            }
        }
    }

    private func toggleLikeAsync(id: String) async {
        guard !isLikeUpdating else { return }
        isLikeUpdating = true
        defer { isLikeUpdating = false }

        let updatedLikes: [String]?
        if likedIds.contains(id) {
            updatedLikes = await profileService.removeLikeFromNft(profileId: profileId, nftId: id)
        } else {
            updatedLikes = await profileService.addLikeForNft(profileId: profileId, nftId: id)
        }

        guard let updatedLikes else { return }
        likedIds = Set(updatedLikes)
    }

    private func loadNfts(ids: [String]) async -> [Nft] {
        await withTaskGroup(of: Nft?.self) { group in
            for id in ids {
                group.addTask { [nftService] in
                    do { return try await nftService.loadNft(id: id) }
                    catch {
                        debugPrint("MyNfts load failed for id=\(id):", error)
                        return nil
                    }
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

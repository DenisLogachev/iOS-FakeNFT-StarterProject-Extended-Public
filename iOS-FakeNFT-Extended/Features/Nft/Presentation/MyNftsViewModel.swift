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

import Foundation

@Observable
@MainActor
final class MyNftsViewModel {
    private let nftService: NftService
    private let myNftsStore: MyNftsStore

    private(set) var state: MyNftsState = .idle
    private(set) var isLoading: Bool = false

    private var hasLoadedOnce = false
    private var isLoadingTaskRunning = false

    init(nftService: NftService, myNftsStore: MyNftsStore) {
        self.nftService = nftService
        self.myNftsStore = myNftsStore
    }

    func load() async {
        guard !isLoadingTaskRunning else { return }
        isLoadingTaskRunning = true
        defer { isLoadingTaskRunning = false }

        isLoading = true
        defer { isLoading = false }

        let ids = await myNftsStore.getMyNftIds()
        guard !ids.isEmpty else {
            state = .empty
            hasLoadedOnce = true
            return
        }

        let loadedNfts = await loadNftsIgnoringFailures(ids: ids)

        if loadedNfts.isEmpty {
            state = .empty
        } else {
            let ordered = ids.compactMap { id in loadedNfts.first(where: { $0.id == id }) }
            state = .loaded(ordered)
        }

        hasLoadedOnce = true
    }

    func toggleLike(id: String) { }
    func isLiked(id: String) -> Bool { false }

    private func loadNftsIgnoringFailures(ids: [String]) async -> [Nft] {
        await withTaskGroup(of: Nft?.self) { group in
            for id in ids {
                group.addTask { [nftService] in
                    do {
                        return try await nftService.loadNft(id: id)
                    } catch {
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

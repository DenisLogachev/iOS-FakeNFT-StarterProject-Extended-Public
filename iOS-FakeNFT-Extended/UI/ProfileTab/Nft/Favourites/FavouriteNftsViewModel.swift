//
//  FavouriteNftsViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Aida Zhdanova on 02.02.2026.
//

import Foundation

enum FavouriteNftsState: Sendable {
    case idle
    case loaded([NFTItem])
    case empty
}

@Observable
@MainActor
final class FavouriteNftsViewModel {
    private var profile: Profile
    private let profileRepo: ProfileRepository
    private let nftRepo: NFTsRepository

    private(set) var state: FavouriteNftsState = .idle
    private(set) var isLoading: Bool = false
    private(set) var isLikeUpdating: Bool = false

    private var isLoadingTaskRunning = false

    init(serviceAssembly: ServicesAssembly, profile: Profile)
    {
        self.profileRepo = serviceAssembly.profileRepo
        self.nftRepo = serviceAssembly.nftRepo
        self.profile = profile
    }
    
    func load() async {
        do {
            if let profileLikes = profile.likes, profileLikes.count > 0  {
                let nfts = try await nftRepo.getNFTs(ids: profileLikes, sortOrder: .byInput, forceRefresh: false)
                state = nfts.isEmpty ? .empty : .loaded(nfts)
            } else {
                state = .empty
            }
        } catch {
            debugPrint("Favorites nfts loading failed, error: \(error)")
        }
    }

    func isLiked(id: String) -> Bool {
        profile.likes?.contains(id) ?? false
    }

    func toggleLike(id: String) {
        Task { [weak self] in
            do {
                try await self?.toggleLikeAsync(id: id)
            } catch {
                debugPrint("Error toggling like: \(error)")
            }
        }
    }

    private func toggleLikeAsync(id: String) async throws {
        guard !isLikeUpdating else { return }
        isLikeUpdating = true
        defer { isLikeUpdating = false }

        guard let likedIds = profile.likes, likedIds.contains(id) else { return }
        profile = try await profileRepo.toggleLikeNFT(nftId: id)
        
        await load()
    }
}

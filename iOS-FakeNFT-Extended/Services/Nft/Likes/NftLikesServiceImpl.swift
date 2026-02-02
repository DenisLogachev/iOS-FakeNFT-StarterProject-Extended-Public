//
//  NftLikesServiceImpl.swift
//  iOS-FakeNFT-Extended
//
//  Created by Aida Zhdanova on 02.02.2026.
//

import Foundation

protocol NftLikesService: Sendable {
    func getLikedNftIds(profileId: Int) async -> [String]
    func addLike(profileId: Int, nftId: String) async -> [String]?
    func removeLike(profileId: Int, nftId: String) async -> [String]?
}

actor NftLikesServiceImpl: NftLikesService {
    private let profileService: ProfileService

    init(profileService: ProfileService) {
        self.profileService = profileService
    }

    func getLikedNftIds(profileId: Int) async -> [String] {
        await profileService.getProfileLikes(id: profileId)
    }

    func addLike(profileId: Int, nftId: String) async -> [String]? {
        await profileService.addLikeForNft(profileId: profileId, nftId: nftId)
    }

    func removeLike(profileId: Int, nftId: String) async -> [String]? {
        await profileService.removeLikeFromNft(profileId: profileId, nftId: nftId)
    }
}

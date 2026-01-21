//
//  ProfileViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Aida Zhdanova on 20.01.2026.
//

import SwiftUI

enum ProfileState: Sendable {
    case idle
    case loading
    case loaded(Profile)
}

@Observable
@MainActor
final class ProfileViewModel {
    var path: [ProfileRoute] = []
    var state: ProfileState = .idle

    private let service: ProfileService
    private let profileId: Int
    private var hasLoaded = false

    init(service: ProfileService, profileId: Int = 1) {
        self.service = service
        self.profileId = profileId
    }

    func load() async {
        guard !hasLoaded else { return }
        hasLoaded = true

        let hadCachedData: Bool
        if let cached = await service.cachedProfile(id: profileId) {
            state = .loaded(cached)
            hadCachedData = true
        } else {
            state = .loading
            hadCachedData = false
        }

        if let fresh = await service.fetchProfile(id: profileId) {
            state = .loaded(fresh)
        } else if !hadCachedData {
            state = .idle
        }
    }
}

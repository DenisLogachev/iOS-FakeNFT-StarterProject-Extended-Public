//
//  ProfileViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Aida Zhdanova on 20.01.2026.
//

import SwiftUI

enum ProfileState: Sendable {
    case idle
    case loaded(Profile)
}

@Observable
@MainActor
final class ProfileViewModel {
    var path: [ProfileRoute] = []
    var state: ProfileState = .idle
    var isLoading: Bool = false

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

        if let cached = await service.cachedProfile(id: profileId) {
            state = .loaded(cached)
        }

        isLoading = true
        defer { isLoading = false }

        if let fresh = await service.fetchProfile(id: profileId) {
            state = .loaded(fresh)
        }
    }
}

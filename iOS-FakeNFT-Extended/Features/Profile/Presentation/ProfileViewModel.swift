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

    private(set) var path: [ProfileRoute] = []
    private(set) var state: ProfileState = .idle
    private(set) var isLoading: Bool = false

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

        setLoading(true)
        defer { setLoading(false) }

        if let fresh = await service.fetchProfile(id: profileId) {
            state = .loaded(fresh)
        }
    }
    
    func setPath(_ newValue: [ProfileRoute]) {
        path = newValue
    }

    func openEdit() {
        path.append(.editProfile)
    }

    func openMyNFTs() {
        path.append(.myNfts)
    }

    func openFavourites() {
        path.append(.favourites)
    }

    func openWebsite(_ url: URL) {
        path.append(.website(url))
    }

    private func setLoading(_ value: Bool) {
        isLoading = value
    }
}

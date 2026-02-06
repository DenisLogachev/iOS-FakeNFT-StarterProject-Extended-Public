//
//  ProfileViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Aida Zhdanova on 20.01.2026.
//

import SwiftUI
import Combine

enum ProfileState: Sendable {
    case idle
    case loaded(Profile)
}

@Observable
@MainActor
final class ProfileViewModel {
    var isLoading: Bool { profile == nil }
    var path: [ProfileRoute] = []
    
    private(set) var state: ProfileState = .idle
    private(set) var avatarReloadToken = UUID()
    private(set) var myNftsCount: Int = 0
    
    private var profile: Profile?
    private var cancellables = Set<AnyCancellable>()
    
    private let profileRepo: ProfileRepository
    
    init(serviceAss: ServicesAssembly) {
        self.profileRepo = serviceAss.profileRepo
        
        profileRepo.updatePublisher.onProfileUpdate { [weak self] profile in
            self?.updateProfileInfo(for: profile)
        }
        .store(in: &cancellables)
    }

    func setPath(_ newValue: [ProfileRoute]) { path = newValue }
    
    func updateProfileInfo(for profile: Profile?) {
        guard let profile, self.profile != profile else { return }
        self.profile = profile
        myNftsCount = profile.nftCount
        applyUpdatedProfile(profile)
        state = .loaded(profile)
    }

    func goTo(destination: ProfileRoute) {
        guard let profile else { return }
        switch destination {
        case .myNfts:
            path.append(.myNfts(profile: profile))
        case .favourites:
            path.append(.favourites(profile: profile))
        case .editProfile:
            path.append(.editProfile(profile: profile))
        case .website:
            guard let url = URL(string: profile.website ?? "") else { return }
            path.append(.website(url: url))
        }
    }

    func applyUpdatedProfile(_ profile: Profile) {
        if case let .loaded(currentProfile) = state {
            refreshAvatar(currentProfile.avatarURL != profile.avatarURL)
        }
        state = .loaded(profile)
    }
    
    func refreshAvatar(_ isNeeded: Bool) {
        if isNeeded { avatarReloadToken = UUID() }
    }
}

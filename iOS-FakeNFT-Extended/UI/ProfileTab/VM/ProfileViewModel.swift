//
//  ProfileViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Aida Zhdanova on 20.01.2026.
//

import SwiftUI
import Combine

@Observable
@MainActor
final class ProfileViewModel {
    var isLoading: Bool { state.isLoading }
    var path: [ProfileRoute] = []
    
    private(set) var state: ProfileState = .idle
    private(set) var avatarReloadToken = UUID()
    
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
        guard let profile else { return }
        refreshAvatar(for: profile)
        state = .loaded(profile)
    }

    func goTo(destination: ProfileRoute) {
        guard case let .loaded(profile) = state else { return }
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
    
    func refreshAvatar(for newProfile: Profile) {
        if case let .loaded(currentProfile) = state, currentProfile.avatarURL != newProfile.avatarURL {
            avatarReloadToken = UUID()
        }
    }
}

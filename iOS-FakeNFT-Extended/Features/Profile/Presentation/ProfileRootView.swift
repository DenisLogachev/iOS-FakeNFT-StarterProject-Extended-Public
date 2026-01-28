//
//  ProfileRootView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Aida Zhdanova on 20.01.2026.
//

import SwiftUI

struct ProfileRootView: View {
    @Bindable var viewModel: ProfileViewModel
    private let profileService: ProfileService

    init(viewModel: ProfileViewModel, profileService: ProfileService) {
        self.viewModel = viewModel
        self.profileService = profileService
    }

    var body: some View {
        NavigationStack(
            path: Binding(
                get: { viewModel.path },
                set: { viewModel.setPath($0) }
            )
        ) {
            ProfileView(viewModel: viewModel)
                .navigationDestination(for: ProfileRoute.self) { destination(for: $0) }
        }
    }

    @ViewBuilder
    private func destination(for route: ProfileRoute) -> some View {
        switch route {
        case .myNfts, .favourites:
            EmptyView()

        case .editProfile(let profileId):
            if case .loaded(let profile) = viewModel.state {
                ProfileEditView(
                    viewModel: ProfileEditViewModel(
                        profile: profile,
                        service: profileService
                    )
                )
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

        case .website(let url):
            AppWebView(url: url)
        }
    }
}

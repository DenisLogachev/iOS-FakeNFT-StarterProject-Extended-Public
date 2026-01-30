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
    private let nftService: NftService
    private let myNftsStore: MyNftsStore // ✅

    init(
        viewModel: ProfileViewModel,
        profileService: ProfileService,
        nftService: NftService,
        myNftsStore: MyNftsStore // ✅
    ) {
        self.viewModel = viewModel
        self.profileService = profileService
        self.nftService = nftService
        self.myNftsStore = myNftsStore // ✅
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
        case .favourites:
            EmptyView()

        case .myNfts:
            MyNftsView(
                viewModel: MyNftsViewModel(
                    nftService: nftService,
                    myNftsStore: myNftsStore
                )
            )

        case .editProfile(let profileId):
            if case .loaded(let profile) = viewModel.state {
                ProfileEditView(
                    viewModel: ProfileEditViewModel(
                        profileId: profileId,
                        profile: profile,
                        service: profileService,
                        onSaved: { updated in
                            viewModel.applyUpdatedProfile(updated)
                        }
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

//
//  ProfileTabView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Aida Zhdanova on 20.01.2026.
//

import SwiftUI

struct ProfileTabView: View {
    @State private var viewModel: ProfileViewModel

    private let profileService: ProfileService
    private let nftService: NftService
    private let myNftsStore: MyNftsStore

    init(
        profileService: ProfileService,
        nftService: NftService,
        myNftsStore: MyNftsStore,
        profileId: Int = 1
    ) {
        self.profileService = profileService
        self.nftService = nftService
        self.myNftsStore = myNftsStore

        _viewModel = State(
            initialValue: ProfileViewModel(
                service: profileService,
                myNftsStore: myNftsStore,
                profileId: profileId
            )
        )
    }

    var body: some View {
        ProfileRootView(
            viewModel: viewModel,
            profileService: profileService,
            nftService: nftService,
            myNftsStore: myNftsStore
        )
    }
}

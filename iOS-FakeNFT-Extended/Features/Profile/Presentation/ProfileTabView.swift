//
//  ProfileTabView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Aida Zhdanova on 20.01.2026.
//

import SwiftUI

struct ProfileTabView: View {
    @State private var viewModel: ProfileViewModel

    init(profileService: ProfileService, profileId: Int = 1) {
        _viewModel = State(
            initialValue: ProfileViewModel(service: profileService, profileId: profileId)
        )
    }

    var body: some View {
        ProfileRootView(viewModel: viewModel)
    }
}

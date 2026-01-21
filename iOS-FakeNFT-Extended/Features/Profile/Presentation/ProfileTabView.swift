//
//  ProfileTabView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Aida Zhdanova on 20.01.2026.
//

import SwiftUI

struct ProfileTabView: View {
    @Environment(ServicesAssembly.self) private var servicesAssembly
    @State private var viewModel: ProfileViewModel?

    var body: some View {
        Group {
            if let viewModel {
                ProfileRootView(viewModel: viewModel)
            } else {
                Color.clear
                    .task {
                        guard viewModel == nil else { return }
                        viewModel = ProfileViewModel(service: servicesAssembly.profileService, profileId: 1)
                    }
            }
        }
    }
}

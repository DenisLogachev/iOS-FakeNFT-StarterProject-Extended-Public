//
//  ProfileRootView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Aida Zhdanova on 20.01.2026.
//

import SwiftUI

struct ProfileRootView: View {
    @Environment(ServicesAssembly.self) private var serviceAss
    @Bindable var viewModel: ProfileViewModel

    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationStack(path: $viewModel.path) {
            ProfileView(viewModel: viewModel)
                .navigationDestination(for: ProfileRoute.self) { destination(for: $0) }
        }
        .toolbar(viewModel.path.isEmpty ? .visible : .hidden, for: .tabBar)
    }

    @ViewBuilder
    private func destination(for route: ProfileRoute) -> some View {
        switch route {
        case .favourites(let profile):
            FavouriteNftsView(viewModel: .init(serviceAssembly: serviceAss, profile: profile))
        case .myNfts(let profile):
            MyNftsView(viewModel: .init(serviceAssembly: serviceAss, profile: profile))
        case .editProfile(let profile):
            ProfileEditView(viewModel: .init(serviceAssembly: serviceAss, profile: profile))
        case .website(let url):
            AppWebView(url: url)
        }
    }
}

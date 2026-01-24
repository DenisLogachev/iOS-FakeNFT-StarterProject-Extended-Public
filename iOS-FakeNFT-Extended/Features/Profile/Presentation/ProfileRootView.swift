//
//  ProfileRootView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Aida Zhdanova on 20.01.2026.
//

import SwiftUI

struct ProfileRootView: View {
    @Bindable var viewModel: ProfileViewModel

    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
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
        case .myNfts, .favourites, .editProfile:
            EmptyView()
        case .website(let url):
            AppWebView(url: url)
        }
    }
}

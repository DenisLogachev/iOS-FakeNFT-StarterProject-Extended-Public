//
//  ProfileRootView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Aida Zhdanova on 20.01.2026.
//

import SwiftUI

struct ProfileRootView: View {
    @State private var viewModel = ProfileViewModel()

    var body: some View {
        NavigationStack(path: $viewModel.path) {
            ProfileView(viewModel: viewModel)
                .navigationDestination(for: ProfileRoute.self) { destination(for: $0) }
        }
    }

    @ViewBuilder
    private func destination(for route: ProfileRoute) -> some View {
        switch route {
        case .myNfts:
            EmptyView()
        case .favourites:
            EmptyView()
        case .editProfile:
            EmptyView()
        case .website(let url):
            EmptyView()
        }
    }
}

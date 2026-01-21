//
//  ProfileView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Aida Zhdanova on 20.01.2026.
//

import SwiftUI

struct ProfileView: View {
    let viewModel: ProfileViewModel

    var body: some View {
        Color.clear
            .task {
                await viewModel.load()
            }
    }
}

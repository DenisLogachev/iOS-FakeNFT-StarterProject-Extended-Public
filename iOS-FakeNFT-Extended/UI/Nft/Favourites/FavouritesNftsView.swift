//
//  FavouritesNftsView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Aida Zhdanova on 02.02.2026.
//

import SwiftUI

struct FavouriteNftsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: FavouriteNftsViewModel

    private enum Layout {
        static let horizontalPadding: CGFloat = 16
        static let gridSpacing: CGFloat = 20
        static let verticalPadding: CGFloat = 20
        static let emptyFontSize: CGFloat = 17

        static let columns: [GridItem] = [
            GridItem(.flexible(minimum: 0), spacing: gridSpacing),
            GridItem(.flexible(minimum: 0), spacing: gridSpacing)
        ]
    }

    init(viewModel: FavouriteNftsViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ZStack {
            Color(.ypWhite).ignoresSafeArea()

            content

            if viewModel.isLoading || viewModel.isLikeUpdating {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationTitle(NSLocalizedString("Profile.favouriteNFT", comment: ""))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button { dismiss() } label: { Image(.icBackward) }
                    .buttonStyle(.plain)
            }
        }
        .task { await viewModel.load() }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .empty:
            Text(NSLocalizedString("Profile.emptyFavNft", comment: ""))
                .font(.system(size: Layout.emptyFontSize, weight: .bold))
                .foregroundStyle(.ypBlack)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .loaded(let nfts):
            ScrollView {
                LazyVGrid(columns: Layout.columns, spacing: Layout.gridSpacing) {
                    ForEach(nfts) { nft in
                        FavouriteNftCell(
                            nft: nft,
                            isFavourite: viewModel.isLiked(id: nft.id),
                            onLikeTap: { viewModel.toggleLike(id: nft.id) }
                        )
                    }
                }
                .padding(.horizontal, Layout.horizontalPadding)
                .padding(.vertical, Layout.verticalPadding)
            }
        }
    }
}

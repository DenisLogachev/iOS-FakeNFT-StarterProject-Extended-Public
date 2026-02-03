//
//  MyNftsView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Aida Zhdanova on 30.01.2026.
//

import SwiftUI

struct MyNftsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: MyNftsViewModel
    @State private var isSortDialogPresented = false

    private enum Layout {
        static let horizontalPadding: CGFloat = 16
        static let trailingPadding: CGFloat = 39
        static let verticalCellPadding: CGFloat = 16

        static let emptyFontSize: CGFloat = 17
    }

    init(viewModel: MyNftsViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ZStack {
            Color(.ypWhite).ignoresSafeArea()
            content

            if viewModel.isLoading, case .loaded = viewModel.state {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .allowsHitTesting(false)
            }
        }
        .navigationTitle(NSLocalizedString("MyNfts.title", comment: ""))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button { dismiss() } label: {
                    Image(.icBackward)
                        .frame(width: 24, height: 24, alignment: .leading)
                }
                .buttonStyle(.plain)
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isSortDialogPresented = true
                } label: {
                    Image(.icSort)
                        .frame(width: 42, height: 42, alignment: .trailing)
                }
                .buttonStyle(.plain)
            }
        }
        .task { await viewModel.load() }
        .confirmationDialog(
            NSLocalizedString("MyNfts.sort.title", comment: ""),
            isPresented: $isSortDialogPresented,
            titleVisibility: .visible
        ) {
            Button(NSLocalizedString("MyNfts.sort.byPrice", comment: "")) {
                viewModel.setSortType(.byPrice)
            }

            Button(NSLocalizedString("MyNfts.sort.byRating", comment: "")) {
                viewModel.setSortType(.byRating)
            }

            Button(NSLocalizedString("MyNfts.sort.byName", comment: "")) {
                viewModel.setSortType(.byName)
            }

            Button(NSLocalizedString("MyNfts.sort.close", comment: ""), role: .cancel) { }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        case .empty:
            Text(NSLocalizedString("MyNfts.empty", comment: ""))
                .font(.system(size: Layout.emptyFontSize, weight: .bold))
                .foregroundStyle(.ypBlack)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, Layout.horizontalPadding)
            
        case .loaded(let nfts):
            List {
                ForEach(nfts) { nft in
                    MyNftRow(
                        nft: nft,
                        isLiked: viewModel.isLiked(id: nft.id),
                        onToggleLike: { viewModel.toggleLike(id: nft.id) }
                    )
                    .padding(.leading, Layout.horizontalPadding)
                    .padding(.trailing, Layout.trailingPadding)
                    .padding(.vertical, Layout.verticalCellPadding)
                    .listRowInsets(.init())
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .refreshable {
                await viewModel.refresh()
            }
        }
    }
}

private struct MyNftRow: View {
    let nft: Nft
    let isLiked: Bool
    let onToggleLike: () -> Void

    private enum Layout {
        static let spacing: CGFloat = 20
        static let imageSize: CGFloat = 108
        static let priceColumnWidth: CGFloat = 85
        static let infoSpacing: CGFloat = 4
        static let priceSpacing: CGFloat = 2
        static let titleFontSize: CGFloat = 17
        static let subtitleFontSize: CGFloat = 13
    }

    var body: some View {
        HStack(spacing: Layout.spacing) {
            NFTPreviewLikeView(
                imageURL: nft.images?.first,
                isLiked: isLiked,
                size: Layout.imageSize,
                buttonPadding: 8,
                onToggleLike: onToggleLike
            )

            VStack(alignment: .leading, spacing: Layout.infoSpacing) {
                Text(nft.name ?? "")
                    .font(.system(size: Layout.titleFontSize, weight: .bold))
                    .foregroundStyle(.ypBlack)
                    .lineLimit(2)

                RatingStars(rating: nft.rating ?? 0)

                Text(
                    String(
                        format: NSLocalizedString("MyNfts.author", comment: ""),
                        nft.author ?? ""
                    )
                )
                .font(.system(size: Layout.subtitleFontSize, weight: .regular))
                .foregroundStyle(.ypBlack)
                .lineLimit(2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Spacer()

            VStack(alignment: .leading, spacing: Layout.priceSpacing) {
                Text(NSLocalizedString("MyNfts.price", comment: ""))
                    .font(.system(size: Layout.subtitleFontSize, weight: .regular))
                    .foregroundStyle(.ypBlack)

                NFTPriceText(
                    price: nft.price,
                    fontSize: Layout.titleFontSize,
                    fontWeight: .bold
                )
            }
            .frame(width: Layout.priceColumnWidth, alignment: .leading)
        }
    }
}

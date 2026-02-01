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
            }
        }
        .navigationTitle(NSLocalizedString("MyNfts.title", comment: ""))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button { dismiss() } label: { Image(.icBackward) }
                    .buttonStyle(.plain)
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button { } label: { Image(.icSort) }
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
        static let imageCornerRadius: CGFloat = 12

        static let priceColumnWidth: CGFloat = 85

        static let infoSpacing: CGFloat = 4
        static let priceSpacing: CGFloat = 2

        static let titleFontSize: CGFloat = 17
        static let subtitleFontSize: CGFloat = 13
    }

    var body: some View {
        HStack(spacing: Layout.spacing) {
            previewSection

            descriptionSection
                .frame(maxWidth: .infinity, alignment: .leading)

            Spacer()

            priceSection
                .frame(width: Layout.priceColumnWidth, alignment: .leading)
        }
    }

    private var previewSection: some View {
        ZStack(alignment: .topTrailing) {
            RemoteImageView(url: nft.images?.first) {
                Color(.ypLightGray)
            }
            .frame(width: Layout.imageSize, height: Layout.imageSize)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: Layout.imageCornerRadius,
                    style: .continuous
                )
            )

            Button(action: onToggleLike) {
                Image(isLiked ? .icFavoritesSelected : .icFavoritesUnselected)
            }
            .buttonStyle(.plain)
            .padding(8)
        }
    }

    private var descriptionSection: some View {
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
    }

    private var priceSection: some View {
        VStack(alignment: .leading, spacing: Layout.priceSpacing) {
            Text(NSLocalizedString("MyNfts.price", comment: ""))
                .font(.system(size: Layout.subtitleFontSize, weight: .regular))
                .foregroundStyle(.ypBlack)

            Text("\(formatPrice(nft.price ?? 0)) ETH")
                .font(.system(size: Layout.titleFontSize, weight: .bold))
                .foregroundStyle(.ypBlack)
                .lineLimit(1)
        }
    }

    private func formatPrice(_ value: Double) -> String {
        Self.priceFormatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }

    private static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.decimalSeparator = ","
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        return formatter
    }()
}

private struct RatingStars: View {
    let rating: Int
    private let maxRating = 5

    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<maxRating, id: \.self) { index in
                Image(index < rating ? .icStarSelected : .icStarUnselected)
            }
        }
    }
}

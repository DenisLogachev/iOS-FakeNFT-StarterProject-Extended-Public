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
                Button { /* TODO: сортировка позже */ } label: { Image(.icSort) }
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
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(.ypBlack)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, 16)

        case .loaded(let nfts):
            List {
                Color.clear
                    .frame(height: 64)
                    .listRowInsets(.init())
                    .listRowSeparator(.hidden)

                ForEach(nfts) { nft in
                    MyNftRow(
                        nft: nft,
                        isLiked: viewModel.isLiked(id: nft.id),
                        onToggleLike: { viewModel.toggleLike(id: nft.id) }
                    )
                    .listRowInsets(.init(top: 0, leading: 16, bottom: 0, trailing: 0))
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .padding(.bottom, 16)
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

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            preview
                .frame(width: 108, height: 108)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            Spacer().frame(width: 20)

            info
                .frame(maxWidth: .infinity, alignment: .leading)

            price
                .frame(width: 90, alignment: .leading)
                .padding(.trailing, 39)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var preview: some View {
        ZStack(alignment: .topTrailing) {
            RemoteImageView(url: nft.images.first) {
                Color(.ypLightGray)
            }

            Button(action: onToggleLike) {
                Image(isLiked ? .icFavoritesSelected : .icFavoritesUnselected)
            }
            .buttonStyle(.plain)
            .padding(8)
        }
    }

    private var info: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(nft.name)
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(.ypBlack)
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)

            RatingStars(rating: nft.rating)

            Text(String(format: NSLocalizedString("MyNfts.author", comment: ""), nft.author))
                .font(.system(size: 13, weight: .regular))
                .foregroundStyle(.ypBlack)
                .lineLimit(1)
        }
    }

    private var price: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(NSLocalizedString("MyNfts.price", comment: ""))
                .font(.system(size: 13, weight: .regular))
                .foregroundStyle(.ypBlack)

            Text("\(formatPrice(nft.price)) ETH")
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(.ypBlack)
                .lineLimit(1)
        }
    }

    private func formatPrice(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.decimalSeparator = ","
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
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

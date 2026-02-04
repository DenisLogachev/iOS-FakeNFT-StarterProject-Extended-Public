//
//  FavouriteNftCell.swift
//  iOS-FakeNFT-Extended
//
//  Created by Aida Zhdanova on 02.02.2026.
//

import SwiftUI

struct FavouriteNftCell: View {
    let nft: Nft
    let isFavourite: Bool
    let onLikeTap: () -> Void

    private enum Layout {
        static let cellSpacing: CGFloat = 12
        static let imageSize: CGFloat = 80
        static let titleToRatingSpacing: CGFloat = 2
        static let ratingToPriceSpacing: CGFloat = 8
        static let titleFontSize: CGFloat = 17
        static let priceFontSize: CGFloat = 15
    }

    var body: some View {
        HStack(alignment: .center, spacing: Layout.cellSpacing) {
            NFTPreviewLikeView(
                imageURL: nft.images?.first,
                isLiked: isFavourite,
                size: Layout.imageSize,
                buttonPadding: 6,
                onToggleLike: onLikeTap
            )

            VStack(alignment: .leading, spacing: 0) {
                Text(nft.name ?? "")
                    .font(.system(size: Layout.titleFontSize, weight: .bold))
                    .foregroundStyle(.ypBlack)
                    .lineLimit(1)
                    .padding(.bottom, Layout.titleToRatingSpacing)

                RatingStars(rating: nft.rating ?? 0)
                    .padding(.bottom, Layout.ratingToPriceSpacing)

                NFTPriceText(
                    price: nft.price,
                    fontSize: Layout.priceFontSize,
                    fontWeight: .regular
                )
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

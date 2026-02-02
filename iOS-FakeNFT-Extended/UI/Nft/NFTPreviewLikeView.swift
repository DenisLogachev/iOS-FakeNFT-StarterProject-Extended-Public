//
//  NFTPreviewLikeView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Aida Zhdanova on 02.02.2026.
//

import SwiftUI

struct NFTPreviewLikeView: View {
    let imageURL: URL?
    let isLiked: Bool
    let size: CGFloat
    let cornerRadius: CGFloat
    let buttonPadding: CGFloat
    let onToggleLike: () -> Void

    init(
        imageURL: URL?,
        isLiked: Bool,
        size: CGFloat,
        cornerRadius: CGFloat = 12,
        buttonPadding: CGFloat = 8,
        onToggleLike: @escaping () -> Void
    ) {
        self.imageURL = imageURL
        self.isLiked = isLiked
        self.size = size
        self.cornerRadius = cornerRadius
        self.buttonPadding = buttonPadding
        self.onToggleLike = onToggleLike
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            RemoteImageView(url: imageURL) {
                Color(.ypLightGray)
            }
            .frame(width: size, height: size)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))

            Button(action: onToggleLike) {
                Image(isLiked ? .icFavoritesSelected : .icFavoritesUnselected)
            }
            .buttonStyle(.plain)
            .padding(buttonPadding)
        }
    }
}

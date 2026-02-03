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
    let buttonPadding: CGFloat
    let onToggleLike: () -> Void

    @State private var isImageLoaded = false

    var body: some View {
        ZStack(alignment: .topTrailing) {
            RemoteImageView(
                url: imageURL,
                showsLoader: true,
                onStateChange: { state in
                    Task { @MainActor in
                        isImageLoaded = (state == .success)
                    }
                }
            ) {
                Color(.ypLightGray)
            }
            .frame(width: size, height: size)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            if isImageLoaded {
                Button(action: onToggleLike) {
                    Image(isLiked ? .icFavoritesSelected : .icFavoritesUnselected)
                }
                .buttonStyle(.plain)
                .padding(buttonPadding)
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.16), value: isImageLoaded)
    }
}

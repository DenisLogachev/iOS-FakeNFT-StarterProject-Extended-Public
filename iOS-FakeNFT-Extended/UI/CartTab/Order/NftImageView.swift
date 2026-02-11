//
//  NftImageView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Denis on 25/01/2026.
//

import SwiftUI

struct NftImageView: View {
    let imageURL: String
    let nftId: String
    let width: CGFloat
    let height: CGFloat
    
    init(
        imageURL: String,
        nftId: String,
        width: CGFloat = LayoutConstants.nftImageSize,
        height: CGFloat = LayoutConstants.nftImageSize
    ) {
        self.imageURL = imageURL
        self.nftId = nftId
        self.width = width
        self.height = height
    }
    
    var body: some View {
        if let url = URL(string: imageURL) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure:
                    Image(systemName: "photo")
                        .foregroundStyle(.gray)
                @unknown default:
                    EmptyView()
                }
            }
            .id(nftId)
            .frame(width: width, height: height)
            .clipShape(RoundedRectangle(cornerRadius: LayoutConstants.cornerRadius))
        }
    }
}

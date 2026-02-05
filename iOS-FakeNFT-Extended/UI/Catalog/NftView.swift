//
//  NftView.swift
//  iOS-FakeNFT-Extended
//
//  Created by ANTON ZVERKOV on 29.01.2026.
//

import SwiftUI

struct NftView: View {
    
    @Environment(CatalogVM.self) private var catalogVM
    @State private var isInCart: Bool = false
    @State private var isLiked: Bool = false
    
    let nft: NFTItem
    
    var body: some View {
        VStack(alignment: .leading) {
            if let nftUrl = URL(string: nft.images.first ?? "") {
                AsyncImage(url: nftUrl) { phase in
                    switch phase {
                    case .empty:
                        nftLoadingImage()
                    case .success(let image):
                        nftImage(image)
                    case .failure:
                        nftPlaceholderImage()
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                nftPlaceholderImage()
            }
            
            HStack(spacing: .zero) {
                ForEach(1...5, id: \.self) { ratingIndex in
                    Image(systemName: "star.fill")
                        .resizable()
                        .frame(width: 12, height: 12)
                        .foregroundStyle(ratingIndex > nft.rating ? .gray.opacity(0.2) : .yellow)
                }
            }
            
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(nft.name)
                        .font(.system(size: 17, weight: .bold))
                        .lineLimit(1)
                        .foregroundStyle(.primary) //change to custom
                        .padding(.bottom, 4)
                    Text("\(nft.priceString) ETH")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(.primary)
                }
                
                Button {
                    
                    // TODO: add "add to cart" feature
                    
                    isInCart.toggle()
                } label: {
                    
                    // TODO: add "check if NFT was added to cart" feature
                    
                    Image(isInCart ? .icBasketIn : .icBasketOut)
                        .resizable()
                        .scaledToFit()
                        .padding(12)
                }
                .tint(.primary)
                .frame(width: 40, height: 40)
            }
        }
    }
    
    @ViewBuilder
    private func nftImage(_ image: Image) -> some View {
        ZStack(alignment: .topTrailing) {
            image
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            Button {
                
                //TODO: add "likes" feature
                
                isLiked.toggle()
            } label: {
                Image(.icFavoritesUnselected)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                    .padding(12)
                    .foregroundStyle(isLiked ? .ypRed : .ypWhite)
            }
        }
    }
    
    @ViewBuilder
    private func nftPlaceholderImage() -> some View {
        ZStack {
            Image(.daisy)
                .resizable()
                .scaledToFit()
                .blur(radius: 8)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .opacity(0.3)
            Image(systemName: "xmark.app")
        }
    }
    
    @ViewBuilder
    private func nftLoadingImage() -> some View {
        ZStack {
            Color.gray.opacity(0.1)
            ProgressView()
        }
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
    
}

#Preview {
    NftView(nft: NFTItem.mockNFTs.first!)
        .environment(CatalogVM(apiClient: MockAPIClient()))
}

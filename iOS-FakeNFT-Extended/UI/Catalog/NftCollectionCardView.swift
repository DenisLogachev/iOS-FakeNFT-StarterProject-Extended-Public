//
//  NftCollectionCardView.swift
//  iOS-FakeNFT-Extended
//
//  Created by ANTON ZVERKOV on 28.01.2026.
//

import SwiftUI

struct NftCollectionCardView: View {
    
    @Environment(NavigationRouter.self) var navRouter
    @Environment(CatalogVM.self) var catalogVM
    let nftCollection: NFTCollection
    let collectionCover: Image?
    
    var body: some View {
        VStack(alignment: .leading) {
            if let collectionCover {
                fetchedImage(collectionCover)
            } else {
                fetchImage(for: nftCollection)
            }
  
            Text("\(nftCollection.name) (\(nftCollection.nfts.count))")
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(.black)
        }
    }
    
    @ViewBuilder
    private func loadingImage() -> some View {
        ZStack {
            Color.gray.opacity(0.1)
                .frame(height: 140)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            HStack {
                Text("Loading...")
                    .foregroundColor(.gray)
                ProgressView()
            }
        }
    }
    
    @ViewBuilder
    private func fetchedImage(_ image: Image) -> some View {
        image
            .resizable()
            .scaledToFill()
            .frame(height: 140)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
    
    @ViewBuilder
    private func fetchImage(for collection: NFTCollection) -> some View {
        if let url = URL(string: collection.cover) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    loadingImage()
                case .success(let image):
                    fetchedImage(image)
                case .failure:
                    placeholderImage()
                @unknown default:
                    EmptyView()
                }
            }
        } else {
            placeholderImage()
        }
    }
    
    @ViewBuilder
    private func placeholderImage() -> some View {
        ZStack {
            Image(.peachGroup)
                .resizable()
                .scaledToFill()
                .frame(height: 140)
                .blur(radius: 10)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            Text("No Image Available")
                .foregroundColor(.white)
        }
    }
}

#Preview {
    NftCollectionCardView(nftCollection: NFTCollection.mockCollections.first!, collectionCover: Image(.peachGroup))
        .environment(NavigationRouter())
        .environment(CatalogVM())
}


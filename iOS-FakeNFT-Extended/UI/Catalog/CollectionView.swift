//
//  CollectionView.swift
//  iOS-FakeNFT-Extended
//
//  Created by ANTON ZVERKOV on 29.01.2026.
//

import SwiftUI

struct CollectionView: View {
    
    @Environment(NavigationRouter.self) private var navRouter
    @Environment(CatalogVM.self) private var catalogVM
    
    @State private var scrollOffset: CGFloat = .infinity
    @State private var fetchedNFTs: [String: NFTItem?] = [:]
    
    let nftCollection: NFTCollection
    let coverImage: Image?
    
    private let expandedHeight: CGFloat = 310
    private let collapsedHeight: CGFloat = 100
    private let infoHeight: CGFloat = 144
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            collectionGrid()
            
            glassThingy()
            
            collectionCover(scrollOffset)
            
            collectionInfo(scrollOffset)
            
            refreshThingy()
        }
        .ignoresSafeArea()
        .animation(.easeInOut, value: scrollOffset)
        .task {
            do {
                fetchedNFTs = try await catalogVM.loadNFTs(for: nftCollection)
            } catch {
                //TODO: Show error
            }
        }
    }
    
    @ViewBuilder
    private func refreshThingy() -> some View {
        if scrollOffset != .infinity {
            let startY = expandedHeight + infoHeight
            let pull = max(0, scrollOffset - startY)
            let maxPull: CGFloat = 160
            let progress = min(pull / maxPull, 1)
            
            HStack {
                Spacer()
                VStack {
                    Spacer(minLength: startY)
                    
                    VStack(spacing: 8) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 20, weight: .semibold))
                        
                        switch progress {
                        case 0..<0.8:
                            Text("Pull to refresh...")
                                .font(.system(size: 13, weight: .medium))
                                .opacity(progress)
                        case 0.8..<1:
                            Text("Almost...")
                                .font(.system(size: 13, weight: .medium))
                                .opacity(progress)
                        default:
                            Text("OK, fine, Refreshing!")
                                .font(.system(size: 13, weight: .medium))
                        }
                    }
                    .scaleEffect(progress * 1.5)
                    .opacity(progress)
                    .opacity(0.5)
                    .padding(12)
                    Spacer()
                }
                Spacer()
            }
            .padding(16)
            .allowsHitTesting(false)
            .onChange(of: progress) { _, newValue in
                if newValue >= 1 {
                    fetchedNFTs.removeAll()
                    Task { fetchedNFTs = try await catalogVM.refreshNFTs(for: nftCollection) }
                    
                }
            }
        }
    }
    
    @ViewBuilder
    private func glassThingy() -> some View {
        VStack {
            Color.clear.frame(height: infoHeight / 2 + 108)
                .background(.ultraThinMaterial)
            Spacer()
        }
    }
    
    @ViewBuilder
    private func collectionCover(_ scrollOffset: CGFloat) -> some View {
        let height = max(collapsedHeight, min(scrollOffset, expandedHeight)) - 16
        let blurStart: CGFloat = expandedHeight + infoHeight
        let progress = max(0, min(1, (blurStart - scrollOffset) / (blurStart - 100)))
        
        if let coverImage {
            VStack {
                coverImage
                    .resizable()
                    .scaledToFill()
                    .frame(height: height)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .blur(radius: progress * 10)
                Spacer()
            }
        } else {
            coverPlaceholder(height: height, progress: progress)
        }
    }
    
    @ViewBuilder
    private func coverPlaceholder(height: CGFloat, progress: CGFloat) -> some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(.pink)
                Text(nftCollection.name)
                    .font(.largeTitle)
                    .lineLimit(1)
            }
            .frame(height: height)
            .opacity(min(1, 1 - progress))
            .blur(radius: progress * 10)
            Spacer()
        }
    }
    
    @ViewBuilder
    private func collectionInfo(_ scrollOffset: CGFloat) -> some View {
        
        let shouldMoveToTop: Bool = scrollOffset < expandedHeight + infoHeight
        
        VStack(alignment: .leading) {
            Text(nftCollection.name)
                .font(.system(size: 22, weight: .bold))
                .padding(.bottom, 8)
            HStack {
                Text("Автор коллекции: ")
                    .padding(.bottom, 5)
                Button {
                    navRouter.navigate(to: .author("https://practicum.yandex.ru"))
                } label: {
                    Text(nftCollection.author)
                }
            }
            .font(.system(size: 13, weight: .regular))
            Text(nftCollection.description)
                .font(.system(size: 13, weight: .regular))
                .lineLimit(shouldMoveToTop ? 2 : nil)
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, shouldMoveToTop ? 76 : expandedHeight + 16)
    }
    
    @ViewBuilder
    private func collectionGrid() -> some View {
        ScrollView {
            VStack {
                Color.clear.frame(height: catalogVM.isRefreshingNFTs ? 100 : 0)
                Color.clear.frame(height: expandedHeight + infoHeight)
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 9), count: 3), spacing: 28) {
                    ForEach(nftCollection.uniqueNfts, id: \.self) { nftID in
                        if let nft = fetchedNFTs[nftID], let nft {
                            NftView(nft: nft)
                                .frame(height: 192, alignment: .topLeading)
                        } else {
                            VStack {
                                ZStack {
                                    Color.clear.background(.ultraThinMaterial)
                                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                    PhaseAnimator([0,1]) { phase in
                                        Image(systemName: "gearshape").rotationEffect(Angle(degrees: 360 * phase))
                                    }
                                }
                                .aspectRatio(contentMode: .fill)
                                Color.yellow.opacity(0.2).background(.ultraThickMaterial).clipShape(Capsule())
                                Color.gray.opacity(0.5).background(.ultraThinMaterial).clipShape(Capsule())
                                Color.clear.background(.ultraThinMaterial).clipShape(Capsule())
                            }
                            .frame(height: 192, alignment: .topLeading)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .background(
                    GeometryReader { scrollGeometry in
                        Color.clear
                            .onChange(of: scrollGeometry.frame(in: .global).minY) { _, newValue in
                                scrollOffset = newValue
                            }
                    }
                )
                
                Color.clear.frame(height: 200)
            }
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    CollectionView(nftCollection: NFTCollection.mockCollections.first!, coverImage: Image(.peachGroup))
        .environment(NavigationRouter())
        .environment(CatalogVM())
}

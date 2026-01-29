//
//  CatalogMainView.swift
//  iOS-FakeNFT-Extended
//
//  Created by ANTON ZVERKOV on 28.01.2026.
//

import SwiftUI

struct CatalogMainView: View {

    @Environment(NavigationRouter.self) var navRouter
    @Environment(CatalogVM.self) var catalogVM
    
    @AppStorage("sortOption") private var sortOption: SortOption = .byName
    
    @State private var isShowingSortMenu: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    isShowingSortMenu = true
                } label: {
                    Image(.icSort)
                }
                .tint(.primary)
            }
            .padding(.bottom, 20)
            
            ScrollView(.vertical) {
                LazyVStack(spacing: 21) {
                    ForEach(catalogVM.sortedCollections(by: sortOption)) { collection in
                        Button {
                            navRouter.navigate(to: .collection(collection))
                        } label: {
                            NftCollectionCardView(nftCollection: collection, collectionCover: catalogVM.collectionCovers[collection.id])
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .overlay {
                BlobsView()
                    .opacity(catalogVM.isLoading ? 1 : 0)
                    .animation(.easeIn, value: catalogVM.isLoading)
            }
        }
        .padding(.horizontal, 16)
        .confirmationDialog("Сортировка", isPresented: $isShowingSortMenu, titleVisibility: .visible) {
            Button("По названию") {
                sortOption = .byName
            }
            Button("По количеству NFT") {
                sortOption = .byNFTCount
            }
            Button("Закрыть", role: .cancel) {
                
            }
        }
        .tint(.blue)
        .navigationDestination(for: NavigationRouter.NavDestination.self) { viewToShow in
            destinationView(viewToShow)
        }
    }
    
    @ViewBuilder
    private func destinationView(_ destination: NavigationRouter.NavDestination) -> some View {
        switch destination {
        case .collection(let collection):
            CollectionView(nftCollection: collection, coverImage: catalogVM.collectionCovers[collection.id])
        case .author:
            AuthorView()
        }
    }
}

#Preview {
    CatalogMainView()
        .environment(NavigationRouter())
        .environment(CatalogVM(apiClient: MockAPIClient()))
}

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
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 21) {
                    ForEach(catalogVM.collections) { collection in
                        Button {
                            navRouter.navigate(to: .collection(collection))
                        } label: {
                            NftCollectionCardView(nftCollection: collection, collectionCover: catalogVM.collectionCovers[collection.id])
                        }
                    }
                }
            }
            .overlay {
                BlobsView()
                    .opacity(catalogVM.isLoading ? 1 : 0)
                    .animation(.easeIn, value: catalogVM.isLoading)
            }
        }
        .padding(16)
        .confirmationDialog("Сортировка", isPresented: $isShowingSortMenu, titleVisibility: .visible) {
            Button("По названию") {
                
                //TODO: add sort
                
            }
            Button("По количеству NFT") {
                
                //TODO: add another sort
                
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
            
            //TODO: add collectionView
            
            EmptyView()
        default:
            EmptyView()
        }
    }
}

#Preview {
    CatalogMainView()
        .environment(NavigationRouter())
        .environment(CatalogVM())
}

//
//  CatalogRootView.swift
//  iOS-FakeNFT-Extended
//
//  Created by ANTON ZVERKOV on 06.02.2026.
//

import SwiftUI

struct CatalogRootView: View {
    @Environment(CatalogNavRouter.self) var navigationRouter
    @Bindable var catalogVM: CatalogVM
    
    var body: some View {
        @Bindable var navigationRouter = navigationRouter
        
        NavigationStack(path: $navigationRouter.path) {
            CatalogMainView(viewModel: catalogVM)
        }
    }
    
    @ViewBuilder
    private func destinationView(_ destination: CatalogNavRouter.NavDestination) -> some View {
        switch destination {
        case .collection(let collection):
            CollectionView(catalogVM: catalogVM, nftCollection: collection, coverImage: catalogVM.collectionCovers[collection.id])
        case .author:
            AuthorView()
        }
    }
}

#Preview {
    CatalogRootView(catalogVM: .init(serviceAss: .init(client: MockAPIClient())))
}

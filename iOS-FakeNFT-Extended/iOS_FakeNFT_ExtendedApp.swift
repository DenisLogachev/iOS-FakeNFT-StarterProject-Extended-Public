import SwiftUI

@main
struct iOS_FakeNFT_ExtendedApp: App {
    @State private var navRouter: NavigationRouter = .init()
    @State private var apiProvider: APIClientProvider = .live(baseURL: Secrets.baseURL)
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(navRouter)
                .environment(CatalogVM(apiClient: apiProvider.client))
                .environment(
                    ServicesAssembly(
                        networkClient: DefaultNetworkClient(),
                        nftStorage: NftStorageImpl(),
                        profileStorage: ProfileStorageImpl()
                    )
                )
        }
    }
}

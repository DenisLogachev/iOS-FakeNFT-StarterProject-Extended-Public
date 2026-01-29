import SwiftUI

@main
struct iOS_FakeNFT_ExtendedApp: App {
    @State private var navRouter: NavigationRouter = .init()
    @State private var catalogVM: CatalogVM = .init()
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(navRouter)
                .environment(catalogVM)
                .environment(ServicesAssembly(networkClient: DefaultNetworkClient(), nftStorage: NftStorageImpl()))
        }
    }
}

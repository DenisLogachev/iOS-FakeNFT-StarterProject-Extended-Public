import SwiftUI

@main
struct iOS_FakeNFT_ExtendedApp: App {
    @State private var catalogNavRouter: CatalogNavRouter = .init()
    @State private var apiProvider: APIClientProvider = .live(baseURL: Secrets.baseURL)
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(catalogNavRouter)
                .environment(ServicesAssembly(client: apiProvider.client))
        }
    }
}

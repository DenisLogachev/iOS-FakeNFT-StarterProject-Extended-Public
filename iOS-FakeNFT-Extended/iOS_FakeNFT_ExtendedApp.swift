import SwiftUI

@main
struct iOS_FakeNFT_ExtendedApp: App {
    @State private var navRouter: NavigationRouter = .init()
    @State private var catalogVM: CatalogVM = .init()
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .alert("Не удалось получить данные", isPresented: $catalogVM.showError) {
                    Button("Отмена", role: .cancel) {
                        catalogVM.showError = false
                    }
                    
                    Button("Повторить") {
                        Task { await catalogVM.refreshData() }
                    }
                }
                .environment(navRouter)
                .environment(catalogVM)
                .environment(ServicesAssembly(networkClient: DefaultNetworkClient(), nftStorage: NftStorageImpl()))
        }
    }
}

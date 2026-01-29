import SwiftUI

struct TabBarView: View {
    @Environment(NavigationRouter.self) var navigationRouter
    @Environment(CatalogVM.self) var catalogVM
    
    var body: some View {
        @Bindable var navigationRouter = navigationRouter
        @Bindable var catalogVM = catalogVM
        
        TabView {
            NavigationStack(path: $navigationRouter.path) {
                CatalogMainView()
                    .alert("Не удалось получить данные", isPresented: $catalogVM.showError) {
                        Button("Отмена", role: .cancel) {
                            catalogVM.showError = false
                        }
                        
                        Button("Повторить") {
                            Task { await catalogVM.refreshData() }
                        }
                    }
            }
            .tabItem {
                Label(
                    NSLocalizedString("Tab.catalog", comment: ""),
                    systemImage: "square.stack.3d.up.fill"
                )
            }
        }
        .backgroundStyle(.background)
    }
}

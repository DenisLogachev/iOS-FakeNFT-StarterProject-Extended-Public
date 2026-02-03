import SwiftUI

enum TabTag {
    static let catalog = 0
    static let cart = 1
}

struct TabBarView: View {
<<<<<<< HEAD
    @Environment(NavigationRouter.self) private var navigationRouter
    @Environment(CatalogVM.self) private var catalogVM
    
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
=======
    @Environment(ServicesAssembly.self) var servicesAssembly
    @State private var selectedTab = TabTag.catalog

    var body: some View {
        TabView(selection: $selectedTab) {
            TestCatalogView(selectedTab: $selectedTab)
                .tabItem {
                    Label(String(localized: "Tab.catalog"), systemImage: "square.stack.3d.up.fill")
                }
                .tag(TabTag.catalog)
                .backgroundStyle(.background)

            OrderAssembly(servicesAssembler: servicesAssembly).build()
                .tabItem {
                    Label(String(localized: "Tab.cart"), image: "ic_basket_tabbar")
                }
                .tag(TabTag.cart)
>>>>>>> epic/cart
        }
        .backgroundStyle(.background)
    }
}

import SwiftUI

enum TabTag {
    static let profile = 0
    static let catalog = 1
    static let cart = 2
}

struct TabBarView: View {
    @Environment(CatalogNavRouter.self) private var navigationRouter
    @Environment(ServicesAssembly.self) var servicesAssembly
    @State private var selectedTab = TabTag.profile
    @State private var showErrorAlert: Bool = false
    
    var body: some View {
        @Bindable var navigationRouter = navigationRouter
        
        TabView(selection: $selectedTab) {
            ProfileRootView(viewModel: .init(serviceAss: servicesAssembly))
                .tabItem {
                    Label(
                        NSLocalizedString("Tab.profile", comment: ""),
                        image: .icProfileTabBar
                    )
                }
                .tag(TabTag.profile)
            
            CatalogRootView(catalogVM: .init(serviceAss: servicesAssembly))
                .tabItem {
                    Label(
                        NSLocalizedString("Tab.catalog", comment: ""),
                        systemImage: "square.stack.3d.up.fill"
                    )
                }
                .tag(TabTag.catalog)
            
            OrderView(viewModel: .init(serviceAss: servicesAssembly))
                .tabItem {
                    Label(String(localized: "Tab.cart"), image: "ic_basket_tabbar")
                }
                .tag(TabTag.cart)
        }
        .alert("Не удалось получить данные", isPresented: $showErrorAlert) {
            Button("Отмена", role: .cancel) {
                servicesAssembly.clearErrors()
            }
            
            Button("Повторить") {
                Task { await servicesAssembly.retry() }
            }
        }
        .backgroundStyle(.background)
        .toolbarBackground(Color(.ypWhite), for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
        .onChange(of: servicesAssembly.hasAnyError) { _, newValue in
            showErrorAlert = newValue
        }
    }
}

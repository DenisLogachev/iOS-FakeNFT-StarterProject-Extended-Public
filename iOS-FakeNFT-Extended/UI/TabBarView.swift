import SwiftUI

enum TabTag {
    static let profile = 0
    static let catalog = 1
    static let cart = 2
}

struct TabBarView: View {
    @Environment(ServicesAssembly.self) var servicesAssembly
    
    @State var profileVM: ProfileViewModel
    @State var catalogVM: CatalogVM
    @State var orderVM: OrderViewModel
    
    @State private var selectedTab = TabTag.profile
    @State private var showErrorAlert: Bool = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ProfileRootView(viewModel: profileVM)
                .tabItem {
                    Label(
                        NSLocalizedString("Tab.profile", comment: ""),
                        image: .icProfileTabBar
                    )
                }
                .tag(TabTag.profile)
            
            CatalogRootView(catalogVM: catalogVM)
                .tabItem {
                    Label(
                        NSLocalizedString("Tab.catalog", comment: ""),
                        systemImage: "square.stack.3d.up.fill"
                    )
                }
                .tag(TabTag.catalog)
            
            OrderView(viewModel: orderVM)
                .tabItem {
                    Label(String(localized: "Tab.cart"), image: "ic_basket_tabbar")
                }
                .tag(TabTag.cart)
        }
        .alert("Не удалось получить данные", isPresented: $showErrorAlert) {
            Button("Отмена", role: .cancel) {
                showErrorAlert = false
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
        .onChange(of: selectedTab) {
            if servicesAssembly.hasAnyError {
                Task { await servicesAssembly.retry() }
            }
        }
    }
}

import SwiftUI

enum TabTag {
    static let profile = 0
    static let catalog = 1
    static let cart = 2
}

struct TabBarView: View {
    @Environment(NavigationRouter.self) private var navigationRouter
    @Environment(CatalogVM.self) private var catalogVM
    @Environment(ServicesAssembly.self) var servicesAssembly
    @State private var selectedTab = TabTag.profile

    var body: some View {
        @Bindable var navigationRouter = navigationRouter
        @Bindable var catalogVM = catalogVM

        TabView(selection: $selectedTab) {
            ProfileTabView(
                profileService: servicesAssembly.profileService,
                nftService: servicesAssembly.nftService,
                nftLikesService: servicesAssembly.nftLikesService,
                myNftsStore: servicesAssembly.myNftsStore
            )
            .tabItem {
                Label(
                    NSLocalizedString("Tab.profile", comment: ""),
                    image: .icProfileTabBar
                )
            }
            .tag(TabTag.profile)

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
            .tag(TabTag.catalog)

            OrderAssembly(servicesAssembler: servicesAssembly).build()
                .tabItem {
                    Label(String(localized: "Tab.cart"), image: "ic_basket_tabbar")
                }
            .tag(TabTag.cart)
        }
        .backgroundStyle(.background)
        .toolbarBackground(Color(.ypWhite), for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
    }
}

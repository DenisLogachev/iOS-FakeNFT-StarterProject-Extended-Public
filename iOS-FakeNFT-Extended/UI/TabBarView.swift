import SwiftUI

enum TabTag {
    static let catalog = 0
    static let cart = 1
}

struct TabBarView: View {
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
        }
    }
}

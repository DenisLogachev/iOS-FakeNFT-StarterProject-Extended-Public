import SwiftUI

struct TabBarView: View {
    @Environment(ServicesAssembly.self) var servicesAssembly
    
    var body: some View {
        TabView {
            TestCatalogView()
                .tabItem {
                    Label(
                        String(localized: "Tab.catalog"),
                        systemImage: "square.stack.3d.up.fill"
                    )
                }
                .backgroundStyle(.background)
            
            OrderAssembly(servicesAssembler: servicesAssembly).build()
                .tabItem {
                    Label(
                        String(localized: "Tab.cart"),
                        image: "ic_basket_tabbar"
                    )
                }
        }
    }
}

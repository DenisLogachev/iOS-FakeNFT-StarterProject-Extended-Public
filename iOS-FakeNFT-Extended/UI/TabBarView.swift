import SwiftUI

struct TabBarView: View {
    @Environment(NavigationRouter.self) var navigationRouter
    
    var body: some View {
        @Bindable var navigationRouter = navigationRouter
        
        TabView {
            NavigationStack(path: $navigationRouter.path) {
                CatalogMainView()
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

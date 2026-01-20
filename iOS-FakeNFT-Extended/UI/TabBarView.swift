import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            TestCatalogView()
                .tabItem {
                    Label(
                        NSLocalizedString("Tab.catalog", comment: ""),
                        systemImage: "square.stack.3d.up.fill"
                    )
                }

            ProfileRootView()
                .tabItem {
                    Label(
                        NSLocalizedString("Tab.profile", comment: ""),
                        image: .icProfileTabBar
                    )
                }
        }
    }
}

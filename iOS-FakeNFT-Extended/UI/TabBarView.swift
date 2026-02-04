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
            StatisticsView()
                .tabItem {
                    Label("Статистика", systemImage: "flag.2.crossed.fill")
                }
                .backgroundStyle(.background)
        }
    }
}

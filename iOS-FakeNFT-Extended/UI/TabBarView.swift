import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            ProfileTabView()
                .tabItem {
                    Label(NSLocalizedString("Tab.profile", comment: ""), image: .icProfileTabBar)
            }
        }
    }
}

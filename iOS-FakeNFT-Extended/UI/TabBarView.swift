import SwiftUI

struct TabBarView: View {
    @Environment(ServicesAssembly.self) private var servicesAssembly

    var body: some View {
        TabView {
            ProfileTabView(profileService: servicesAssembly.profileService)
                .tabItem {
                    Label(NSLocalizedString("Tab.profile", comment: ""), image: .icProfileTabBar)
                }
        }
    }
}

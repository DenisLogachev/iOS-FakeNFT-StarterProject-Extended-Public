import SwiftUI

struct TabBarView: View {
    @Environment(ServicesAssembly.self) private var servicesAssembly

    var body: some View {
        TabView {
            ProfileTabView(
                profileService: servicesAssembly.profileService,
                nftService: servicesAssembly.nftService,
                nftLikesService: servicesAssembly.nftLikesService,
                myNftsStore: servicesAssembly.myNftsStoreService
            )
            .tabItem {
                Label(
                    NSLocalizedString("Tab.profile", comment: ""),
                    image: .icProfileTabBar
                )
            }
        }
    }
}

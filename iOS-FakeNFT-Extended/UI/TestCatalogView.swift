import SwiftUI

struct TestCatalogView: View {
    @Environment(ServicesAssembly.self) var servicesAssembly
    @Binding var selectedTab: Int
    @State private var presentingNft = false

    var body: some View {
        Button {
            presentingNft = true
        } label: {
            Text(Constants.openNftTitle)
                .tint(.blue)
        }
        .backgroundStyle(.background)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    selectedTab = TabTag.cart
                } label: {
                    Image.icBasketTabbar
                        .renderingMode(.original)
                }
            }
        }
        .sheet(isPresented: $presentingNft) {
            NftDetailBridgeView()
        }
    }
}

private enum Constants {
    static let openNftTitle = NSLocalizedString("Catalog.openNft", comment: "")
}

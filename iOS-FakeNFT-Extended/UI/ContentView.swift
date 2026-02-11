import SwiftUI

struct ContentView: View {
    @Environment(ServicesAssembly.self) var servicesAssembly
    var body: some View {
        TabBarView(
            profileVM: .init(serviceAss: servicesAssembly),
            catalogVM: .init(serviceAss: servicesAssembly),
            orderVM: .init(serviceAss: servicesAssembly)
        )
    }
}

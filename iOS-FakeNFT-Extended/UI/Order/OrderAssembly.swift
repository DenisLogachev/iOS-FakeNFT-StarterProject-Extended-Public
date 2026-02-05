//
//  OrderAssembly.swift
//  iOS-FakeNFT-Extended
//
//  Created by Denis on 25/01/2026.
//

import SwiftUI

@MainActor
final class OrderAssembly {
    
    private let servicesAssembler: ServicesAssembly
    
    init(servicesAssembler: ServicesAssembly) {
        self.servicesAssembler = servicesAssembler
    }
    
    func build() -> OrderView {
        let viewModel = OrderViewModel(
            orderService: servicesAssembler.orderService,
            nftService: servicesAssembler.nftService
        )
        let currencySelectionAssembly = CurrencySelectionAssembly(servicesAssembler: servicesAssembler)
        return OrderView(
            viewModel: viewModel,
            currencySelectionAssembly: currencySelectionAssembly
        )
    }
}

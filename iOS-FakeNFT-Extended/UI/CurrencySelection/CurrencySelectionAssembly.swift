//
//  CurrencySelectionAssembly.swift
//  iOS-FakeNFT-Extended
//
//  Created by Denis on 25/01/2026.
//

import SwiftUI

@MainActor
final class CurrencySelectionAssembly {
    
    private let servicesAssembler: ServicesAssembly
    
    init(servicesAssembler: ServicesAssembly) {
        self.servicesAssembler = servicesAssembler
    }
    
    func build(onPayTap: @escaping (String) -> Void) -> some View {
        let viewModel = CurrencySelectionViewModel(currencyService: servicesAssembler.currencyService)
        return CurrencySelectionView(viewModel: viewModel, onPayTap: onPayTap)
    }
}

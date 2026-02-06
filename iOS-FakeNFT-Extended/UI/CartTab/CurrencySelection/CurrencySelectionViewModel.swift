//
//  CurrencySelectionViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Denis on 25/01/2026.
//

import Foundation
import Observation

@Observable
@MainActor
final class CurrencySelectionViewModel {
    var currencies: [Currency] = []
    var selectedCurrency: Currency?
    var paymentError: String?
    var isLoading: Bool = false
    
    private let currenciesRepo: CurrenciesRepo
    
    init(serviceAss: ServicesAssembly) {
        self.currenciesRepo = serviceAss.currenciesRepo
    }
    
    // MARK: - Private Methods
    func loadCurrencies() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            currencies = try await currenciesRepo.getAllCurrencies()
            selectedCurrency = currencies.first
        } catch {
            paymentError = String(localized: "Error.network")
        }
    }

    // MARK: - Public Methods
    func selectCurrency(_ currency: Currency) {
        selectedCurrency = currency
    }
    
    func showPaymentError(_ error: String) {
        paymentError = error
    }
    
    func dismissPaymentError() {
        paymentError = nil
    }
    
    func retryPayment() {
        dismissPaymentError()
    }
}

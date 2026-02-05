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
    
    private let currencyService: CurrencyService
    
    init(currencyService: CurrencyService) {
        self.currencyService = currencyService
    }
    
    // MARK: - Private Methods
    func loadCurrencies() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            currencies = try await currencyService.loadCurrencies()
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

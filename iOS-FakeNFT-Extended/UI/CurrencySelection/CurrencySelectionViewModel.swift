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

    init() {
        loadMockData()
    }

    // MARK: - Private Methods
    private func loadMockData() {
        let mockData: [(id: String, title: String, name: String, imagePath: String)] = [
            ("1", "Bitcoin", "BTC", "bitcoin-btc-logo.png"),
            ("2", "Tether", "USDT", "tether-usdt-logo.png"),
            ("3", "Solana", "SOL", "solana-sol-logo.png"),
            ("4", "Cardano", "ADA", "cardano-ada-logo.png"),
            ("5", "Dogecoin", "DOGE", "dogecoin-doge-logo.png"),
            ("6", "ApeCoin", "APE", "apecoin-ape-logo.png"),
            ("7", "Ethereum", "ETH", "ethereum-eth-logo.png"),
            ("8", "Shiba Inu", "SHIB", "shiba-inu-shib-logo.png")
        ]
        
        currencies = mockData.map { data in
            Currency(
                id: data.id,
                title: data.title,
                name: data.name,
                image: URL(string: "https://cryptologos.cc/logos/\(data.imagePath)")!
            )
        }
        
        selectedCurrency = currencies.first
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

//
//  CurrencyService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Denis on 28/01/2026.
//

import Foundation

protocol CurrencyService {
    func loadCurrencies() async throws -> [Currency]
    func loadCurrency(id: String) async throws -> Currency
}

@MainActor
final class CurrencyServiceImpl: CurrencyService {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadCurrencies() async throws -> [Currency] {
        let request = GetCurrenciesRequest()
        return try await networkClient.send(request: request)
    }
    
    func loadCurrency(id: String) async throws -> Currency {
        let request = GetCurrencyByIdRequest(id: id)
        return try await networkClient.send(request: request)
    }
}

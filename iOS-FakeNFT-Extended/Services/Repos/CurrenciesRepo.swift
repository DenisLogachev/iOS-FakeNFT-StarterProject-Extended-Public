//
//  CurrenciesRepo.swift
//  iOS-FakeNFT-Extended
//
//  Created by ANTON ZVERKOV on 05.02.2026.
//

import Foundation
import Combine

enum CurrenciesRepoError: Error {
    case getAllCurrenciesFailed
    case getCurrencyByIdFailed(id: String)
}

@MainActor
protocol CurrencyRepository: AnyObject {
    var error: CurrenciesRepoError? { get }
    
    var currencies: [Currency]? { get }
    var currenciesById: [String: Currency] { get }
    var updatePublisher: AnyPublisher<RepoUpdate, Never> { get }
    
    func loadCurrenciesIfNeeded() async
    func getAllCurrencies(forceRefresh: Bool) async throws -> [Currency]
    func getCurrency(id: String, forceRefresh: Bool) async throws -> Currency
    func retryAfter(error: CurrenciesRepoError) async throws
    func clearError()
}

@MainActor
@Observable
final class CurrenciesRepo: CurrencyRepository {
    var error: CurrenciesRepoError?
    
    private let api: APIClientProtocol
    private let updateSubject = PassthroughSubject<RepoUpdate, Never>()
    
    var currencies: [Currency]? {
        didSet { updateSubject.send(.currenciesUpdate(currencies)) }
    }
    
    var currenciesById: [String: Currency] = [:] {
        didSet { updateSubject.send(.currenciesByIdUpdate(currenciesById)) }
    }
    
    var updatePublisher: AnyPublisher<RepoUpdate, Never> {
        updateSubject.eraseToAnyPublisher()
    }
    
    init(api: APIClientProtocol) {
        self.api = api
        
        Task { await loadCurrenciesIfNeeded() }
    }
    
    /// Loads currencies if they are not already cached.
    ///
    /// - If currencies are already present in memory, does nothing.
    /// - If currencies are not cached, fetches them from the server.
    ///
    /// Errors are silently ignored.
    func loadCurrenciesIfNeeded() async {
        if currencies == nil { currencies = try? await getAllCurrencies() }
    }

    /// Gets all available currencies.
    ///
    /// - If currencies are already present in memory, returns cached values.
    /// - If currencies are not cached or `forceRefresh` is `true`, fetches from server.
    ///
    /// - Parameter forceRefresh: Forces a new fetch from the server even if cached data exists.
    /// - Returns: All currencies.
    func getAllCurrencies(forceRefresh: Bool = false) async throws -> [Currency] {
        do {
            if let currencies, !forceRefresh {
                return currencies
            }
            
            let fresh = try await api.fetchCurrencies()
            self.currencies = fresh
            self.currenciesById = Dictionary(
                uniqueKeysWithValues: fresh.map { ($0.id, $0) }
            )
            return fresh
        } catch {
            self.error = CurrenciesRepoError.getAllCurrenciesFailed
            throw error
        }
    }

    /// Gets a currency by its identifier.
    ///
    /// - If the currency is already present in memory, returns the cached value.
    /// - If the currency is not cached or `forceRefresh` is `true`, fetches from server.
    ///
    /// - Parameters:
    ///   - id: Identifier of the currency.
    ///   - forceRefresh: Forces a new fetch from the server even if cached data exists.
    /// - Returns: Currency with the specified identifier.
    func getCurrency(id: String, forceRefresh: Bool = false) async throws -> Currency {
        do {
            if let cached = currenciesById[id], !forceRefresh {
                return cached
            }
            
            let fresh = try await api.fetchCurrency(id: id)
            currenciesById[id] = fresh
            return fresh
        } catch {
            self.error = CurrenciesRepoError.getCurrencyByIdFailed(id: id)
            throw error
        }

    }
    
    func retryAfter(error: CurrenciesRepoError) async throws {
        self.error = nil
        switch error {
        case .getAllCurrenciesFailed:
            let _ = try await getAllCurrencies(forceRefresh: true)
        case .getCurrencyByIdFailed(let id):
            let _ = try await getCurrency(id: id, forceRefresh: true)
        }
    }
    
    func clearError() {
        self.error = nil
    }
}


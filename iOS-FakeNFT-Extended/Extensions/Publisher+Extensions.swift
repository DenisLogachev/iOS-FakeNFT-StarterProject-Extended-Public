//
//  Publisher+Extensions.swift
//  iOS-FakeNFT-Extended
//
//  Created by ANTON ZVERKOV on 06.02.2026.
//

import Foundation

import Combine

extension Publisher where Output == RepoUpdate, Failure == Never {
    func onCollectionsUpdate(_ handler: @escaping ([NFTCollection]?) -> Void) -> AnyCancellable {
        self.compactMap { update -> [NFTCollection]?? in
            if case .collectionsUpdate(let value) = update {
                return value
            }
            return nil
        }
        .sink { value in
            handler(value)
        }
    }
    
    func onProfileUpdate(_ handler: @escaping (Profile?) -> Void) -> AnyCancellable {
        self.compactMap { update -> Profile?? in
            if case .profileUpdate(let value) = update {
                return value
            }
            return nil
        }
        .sink { value in
            handler(value)
        }
    }
    
    func onCartUpdate(_ handler: @escaping (Cart?) -> Void) -> AnyCancellable {
        self.compactMap { update -> Cart?? in
            if case .cartUpdate(let value) = update {
                return value
            }
            return nil
        }
        .sink { value in
            handler(value)
        }
    }
    
    func onCurrenciesUpdate(_ handler: @escaping ([Currency]?) -> Void) -> AnyCancellable {
        self.compactMap { update -> [Currency]?? in
            if case .currenciesUpdate(let value) = update {
                return value
            }
            return nil
        }
        .sink { value in
            handler(value)
        }
    }
}

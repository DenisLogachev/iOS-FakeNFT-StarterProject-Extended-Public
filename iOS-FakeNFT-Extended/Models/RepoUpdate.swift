//
//  RepoUpdate.swift
//  iOS-FakeNFT-Extended
//
//  Created by ANTON ZVERKOV on 06.02.2026.
//

import Foundation

enum RepoUpdate {
    case collectionsUpdate([NFTCollection]?)
    case collectionsById([String: NFTCollection])
    case nftsUpdate([NFTItem]?)
    case nftsById([String: NFTItem])
    case profileUpdate(Profile?)
    case cartUpdate(Cart?)
    case currenciesUpdate([Currency]?)
    case currenciesByIdUpdate([String: Currency])
}

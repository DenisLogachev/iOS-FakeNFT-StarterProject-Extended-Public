//
//  Currecy.swift
//  iOS-FakeNFT-Extended
//
//  Created by ANTON ZVERKOV on 06.02.2026.
//

import Foundation

struct Currency: Codable {
    let title: String
    let name: String
    let image: String
    let id: String
}

#if DEBUG
extension Currency {
    static let mock: Currency = .init(
        title: "CurrencyTitle",
        name: "CurrencyName",
        image: "https://picsum.photos/400/400?random=8",
        id: UUID().uuidString
    )
}
#endif


//
//  NFTSortingOrder.swift
//  iOS-FakeNFT-Extended
//
//  Created by ANTON ZVERKOV on 07.02.2026.
//

import Foundation

enum NFTSortOrder: String, CaseIterable, Codable {
    case byPrice = "По цене"
    case byRating = "По рейтингу"
    case byName = "По названию"
    case byInput = "Не сортировать"
    
    static let myNFTStorageKey: String = "myNFTSortingOrder"
    static let myOrderStorageKey: String = "myOrderSortingOrder"
}

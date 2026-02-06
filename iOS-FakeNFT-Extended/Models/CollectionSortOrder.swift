//
//  SortOption.swift
//  iOS-FakeNFT-Extended
//
//  Created by ANTON ZVERKOV on 29.01.2026.
//

import Foundation

enum CollectionSortOrder: String {
    case byName
    case byNFTCount
    
    static let storedKey = "CollectionsSortOption"
}

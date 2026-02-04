//
//  MyNftsSortType.swift
//  iOS-FakeNFT-Extended
//
//  Created by Aida Zhdanova on 02.02.2026.
//

import Foundation

enum MyNftsSortType: String, CaseIterable, Sendable {
    case byName
    case byPrice
    case byRating

    static let defaultValue: MyNftsSortType = .byRating
}

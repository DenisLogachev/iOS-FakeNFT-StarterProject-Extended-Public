//
//  MyNftsSortStorage.swift
//  iOS-FakeNFT-Extended
//
//  Created by Aida Zhdanova on 02.02.2026.
//

import Foundation

protocol MyNftsSortStorage: Sendable {
    func loadSortType() async -> MyNftsSortType
    func saveSortType(_ sortType: MyNftsSortType) async
}

actor MyNftsSortStorageImpl: MyNftsSortStorage {
    private let userDefaults: UserDefaults
    private let key: String

    init(
        userDefaults: UserDefaults = .standard,
        key: String = "my_nfts_sort_type"
    ) {
        self.userDefaults = userDefaults
        self.key = key
    }

    func loadSortType() async -> MyNftsSortType {
        guard let rawValue = userDefaults.string(forKey: key),
              let sortType = MyNftsSortType(rawValue: rawValue)
        else {
            return MyNftsSortType.defaultValue
        }
        return sortType
    }

    func saveSortType(_ sortType: MyNftsSortType) async {
        userDefaults.set(sortType.rawValue, forKey: key)
    }
}

//
//  MyNftsStoreImpl.swift
//  iOS-FakeNFT-Extended
//
//  Created by Aida Zhdanova on 30.01.2026.
//

import Foundation

protocol MyNftsStore: Sendable {
    func getMyNftIds() async -> [String]
    func setMyNftIds(_ ids: [String]) async
}

actor MyNftsStoreImpl: MyNftsStore {
    // TODO: потом заменить на UserDefaults
    private var myNftIds: [String] = [
        // TEMP: мок-данные для демонстрации экрана "Мои NFT"
        "28829968-8639-4e08-8853-2f30fcf09783",
        "a06d0075-d1a7-40dc-b710-db6808c28cca"
    ]

    func getMyNftIds() async -> [String] {
        myNftIds
    }

    func setMyNftIds(_ ids: [String]) async {
        myNftIds = ids
    }
}

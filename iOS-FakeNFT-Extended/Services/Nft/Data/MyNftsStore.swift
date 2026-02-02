//
//  MyNftsStore.swift
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
    private var myNftIds: [String] = [
        // TEMP: мок-данные для демонстрации экрана "Мои NFT"
        "28829968-8639-4e08-8853-2f30fcf09783",
        "a06d0075-d1a7-40dc-b710-db6808c28cca",
        "db196ee3-07ef-44e7-8ff5-16548fc6f434",
        "fa03574c-9067-45ad-9379-e3ed2d70df78",
        "89e16821-0a25-44b8-b199-fa8183c19dd9",
        "75a45377-a978-4969-965f-17e0d216a01a",
        "a7efecb7-caf8-412c-838e-01e4d432907b"
    ]

    func getMyNftIds() async -> [String] {
        myNftIds
    }

    func setMyNftIds(_ ids: [String]) async {
        myNftIds = ids
    }
}

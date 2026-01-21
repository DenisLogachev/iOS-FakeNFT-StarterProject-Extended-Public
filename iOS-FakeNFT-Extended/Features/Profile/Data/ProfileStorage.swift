//
//  ProfileStorage.swift
//  iOS-FakeNFT-Extended
//
//  Created by Aida Zhdanova on 20.01.2026.
//

import Foundation

protocol ProfileStorage: AnyObject, Sendable {
    func saveProfile(_ profile: Profile, for id: Int) async
    func getProfile(id: Int) async -> Profile?
}

actor ProfileStorageImpl: ProfileStorage {
    private var storage: [Int: Profile] = [:]

    func saveProfile(_ profile: Profile, for id: Int) async {
        storage[id] = profile
    }

    func getProfile(id: Int) async -> Profile? {
        storage[id]
    }
}

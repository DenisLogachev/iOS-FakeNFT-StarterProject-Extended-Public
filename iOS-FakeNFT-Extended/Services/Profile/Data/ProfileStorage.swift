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
    func getLastUpdated(id: Int) async -> Date?
}

actor ProfileStorageImpl: ProfileStorage {

    private var memoryCache: [Int: Profile] = [:]
    private var lastUpdated: [Int: Date] = [:]

    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    func saveProfile(_ profile: Profile, for id: Int) async {
        memoryCache[id] = profile
        lastUpdated[id] = Date()

        do {
            let data = try encoder.encode(profile)
            UserDefaults.standard.set(data, forKey: profileKey(for: id))
            UserDefaults.standard.set(Date(), forKey: updatedKey(for: id))
        } catch {
            debugPrint("ProfileStorage: encode failed:", error)
        }
    }

    func getProfile(id: Int) async -> Profile? {
        if let cached = memoryCache[id] {
            return cached
        }

        guard let data = UserDefaults.standard.data(forKey: profileKey(for: id)) else {
            return nil
        }

        do {
            let profile = try decoder.decode(Profile.self, from: data)
            memoryCache[id] = profile
            return profile
        } catch {
            debugPrint("ProfileStorage: decode failed:", error)
            return nil
        }
    }

    func getLastUpdated(id: Int) async -> Date? {
        if let date = lastUpdated[id] {
            return date
        }

        let date = UserDefaults.standard.object(forKey: updatedKey(for: id)) as? Date
        lastUpdated[id] = date
        return date
    }

    private func profileKey(for id: Int) -> String {
        "profile_\(id)"
    }

    private func updatedKey(for id: Int) -> String {
        "profile_updated_\(id)"
    }
}

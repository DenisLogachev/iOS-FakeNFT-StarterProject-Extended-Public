//
//  ProfileService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Aida Zhdanova on 20.01.2026.
//

import Foundation

protocol ProfileService: Sendable {
    func cachedProfile(id: Int) async -> Profile?
    func fetchProfile(id: Int) async -> Profile?
}

actor ProfileServiceImpl: ProfileService {
    private let networkClient: NetworkClient
    private let storage: ProfileStorage

    init(networkClient: NetworkClient, storage: ProfileStorage) {
        self.networkClient = networkClient
        self.storage = storage
    }

    func cachedProfile(id: Int) async -> Profile? {
        await storage.getProfile(id: id)
    }

    func fetchProfile(id: Int) async -> Profile? {
        do {
            let profile: Profile = try await networkClient.send(request: ProfileRequest(id: id))
            await storage.saveProfile(profile, for: id)
            return profile
        } catch let error as NetworkClientError {
            if error.isNoInternet {
                debugPrint("Profile fetch: no internet")
            } else if error.isTimedOut {
                debugPrint("Profile fetch: timed out")
            } else {
                debugPrint("Profile fetch failed:", error)
            }
            return nil
        } catch {
            debugPrint("Profile fetch failed:", error)
            return nil
        }
    }
}

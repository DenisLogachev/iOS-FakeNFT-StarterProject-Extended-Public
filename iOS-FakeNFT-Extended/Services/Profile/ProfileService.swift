//
//  ProfileService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Aida Zhdanova on 20.01.2026.
//

import Foundation

protocol ProfileService: Sendable {
    func cachedProfile(id: Int) async -> Profile?
    func fetchProfile(id: Int, forceRefresh: Bool) async -> Profile?
    func updateProfile(id: Int, draft: ProfileEditDraft) async -> Profile?

    func getProfileLikes(id: Int) async -> [String]
    func addLikeForNft(profileId: Int, nftId: String) async -> [String]?
    func removeLikeFromNft(profileId: Int, nftId: String) async -> [String]?
}

actor ProfileServiceImpl: ProfileService {
    private let networkClient: NetworkClient
    private let storage: ProfileStorage

    private let cacheTTL: TimeInterval = 120

    init(networkClient: NetworkClient, storage: ProfileStorage) {
        self.networkClient = networkClient
        self.storage = storage
    }

    func cachedProfile(id: Int) async -> Profile? {
        await storage.getProfile(id: id)
    }

    func fetchProfile(id: Int, forceRefresh: Bool) async -> Profile? {
        if !forceRefresh {
            let cached = await storage.getProfile(id: id)
            let lastUpdated = await storage.getLastUpdated(id: id)

            if let cached, let lastUpdated {
                let age = Date().timeIntervalSince(lastUpdated)
                if age < cacheTTL {
                    return cached
                }
            }
        }

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

    func fetchProfile(id: Int) async -> Profile? {
        await fetchProfile(id: id, forceRefresh: false)
    }

    func updateProfile(id: Int, draft: ProfileEditDraft) async -> Profile? {
        do {
            let updated: Profile = try await networkClient.send(
                request: ProfileUpdateRequest(id: id, draft: draft)
            )
            await storage.saveProfile(updated, for: id)
            return updated
        } catch let error as NetworkClientError {
            if error.isNoInternet {
                debugPrint("Profile update: no internet")
            } else if error.isTimedOut {
                debugPrint("Profile update: timed out")
            } else {
                debugPrint("Profile update failed:", error)
            }
            return nil
        } catch {
            debugPrint("Profile update failed:", error)
            return nil
        }
    }
    
    func getProfileLikes(id: Int) async -> [String] {
        if let cached = await storage.getProfile(id: id),
           let likes = cached.likes {
            return likes
        }
        let fetched = await fetchProfile(id: id, forceRefresh: false)
        return fetched?.likes ?? []
    }

    func addLikeForNft(profileId: Int, nftId: String) async -> [String]? {
        let currentLikes = await getProfileLikes(id: profileId)
        let newLikes = currentLikes.contains(nftId) ? currentLikes : (currentLikes + [nftId])
        return await updateLikes(profileId: profileId, likes: newLikes)
    }

    func removeLikeFromNft(profileId: Int, nftId: String) async -> [String]? {
        let currentLikes = await getProfileLikes(id: profileId)
        let newLikes = currentLikes.filter { $0 != nftId }
        return await updateLikes(profileId: profileId, likes: newLikes)
    }

    private func updateLikes(profileId: Int, likes: [String]) async -> [String]? {
        do {
            let request = UpdateLikesRequest(id: profileId, likes: likes.isEmpty ? nil : likes)
            let updated: Profile = try await networkClient.send(request: request)
            await storage.saveProfile(updated, for: profileId)
            return updated.likes ?? []
        } catch {
            debugPrint("Update likes failed:", error)
            return nil
        }
    }
}

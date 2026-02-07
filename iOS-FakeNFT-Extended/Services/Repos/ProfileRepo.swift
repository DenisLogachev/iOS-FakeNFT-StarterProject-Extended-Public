//
//  ProfileRepo.swift
//  iOS-FakeNFT-Extended
//
//  Created by ANTON ZVERKOV on 05.02.2026.
//

import Foundation
import Combine

enum ProfileRepoError: Error {
    case getProfileFailed
    case updateProfileLikesFailed(likedId: [String])
    case toggleLikeFailed(nftId: String)
    case updateProfileFailed(newProfile: Profile)
}

@MainActor
protocol ProfileRepository: AnyObject {
    var error: ProfileRepoError? { get }
    
    var profile: Profile? { get }
    var updatePublisher: AnyPublisher<RepoUpdate, Never> { get }
    
    func loadProfileIfNeeded() async
    func getProfile(forceRefresh: Bool) async throws -> Profile
    func updateProfileLikes(_ likedNFTIds: [String]) async throws -> Profile
    func updateProfile(_ profile: Profile) async throws -> Profile
    func toggleLikeNFT(nftId: String) async throws -> Profile
    func retryAfter(error: ProfileRepoError) async throws
    func clearError()
}

@MainActor
@Observable
final class ProfileRepo: ProfileRepository {
    var error: ProfileRepoError?
    
    private let api: APIClientProtocol
    private let updateSubject = PassthroughSubject<RepoUpdate, Never>()
    
    var profile: Profile? {
        didSet { updateSubject.send(.profileUpdate(profile)) }
    }
    
    var updatePublisher: AnyPublisher<RepoUpdate, Never> {
        updateSubject.eraseToAnyPublisher()
    }
    
    init(api: APIClientProtocol) {
        self.api = api
        
        Task { await loadProfileIfNeeded() }
    }
    
    /// Loads user profile if it is not already cached.
    ///
    /// - If the profile is already present in memory, does nothing.
    /// - If the profile is not cached, fetches it from the server.
    ///
    /// Errors are silently ignored.
    func loadProfileIfNeeded() async {
        if profile == nil { profile = try? await getProfile() }
    }

    /// Gets the current user profile.
    ///
    /// - If the profile is already present in memory, returns the cached value.
    /// - If the profile is not cached or `forceRefresh` is `true`, fetches from server.
    ///
    /// - Parameter forceRefresh: Forces a new fetch from the server even if cached data exists.
    /// - Returns: User profile.
    func getProfile(forceRefresh: Bool = false) async throws -> Profile {
        do {
            if let profile, !forceRefresh {
                return profile
            }
            
            let fresh = try await api.fetchProfile()
            self.profile = fresh
            return fresh
        } catch {
            self.error = .getProfileFailed
            throw error
        }
    }

    /// Updates liked NFT identifiers for the current user profile.
    ///
    /// - Sends updated liked NFT IDs to the server.
    /// - Replaces all liked IDs in user profile to sent data.
    /// - Updates cached profile with the server response.
    ///
    /// - Parameter likedNFTIds: Identifiers of liked NFTs.
    /// - Returns: Updated user profile.
    func updateProfileLikes(_ likedNFTIds: [String]) async throws -> Profile {
        do {
            let updated = try await api.updateProfileLikes(likedNFTIds: likedNFTIds)
            self.profile = updated
            return updated
        } catch {
            self.error = .updateProfileLikesFailed(likedId: likedNFTIds)
            throw error
        }
    }
    
    /// Toggles NFT like in user profile.
    ///
    /// - Sends updated profile data to the server.
    /// - Updates cached profile with the server response.
    ///
    /// - Parameter nftId: NFT identifier to toggle.
    /// - Returns: Updated user profile.
    func toggleLikeNFT(nftId: String) async throws -> Profile {
        do {
            let currentLikes =  try await getProfile().likes ?? []
            let updatedLikes = Set(currentLikes).symmetricDifference(Set([nftId]))
            return try await updateProfileLikes(Array(updatedLikes))
        } catch {
            self.error = .toggleLikeFailed(nftId: nftId)
            throw error
        }
    }

    /// Updates user profile information.
    ///
    /// - Sends updated profile data to the server.
    /// - Updates cached profile with the server response.
    ///
    /// - Parameter profile: Updated Profile to replace existing.
    /// - Returns: Updated user profile.
    func updateProfile(_ profile: Profile) async throws -> Profile {
        do {
            let updated = try await api.updateProfile(profile)
            self.profile = updated
            return updated
        } catch {
            self.error = .updateProfileFailed(newProfile: profile)
            throw error
        }
    }
    
    func retryAfter(error: ProfileRepoError) async throws {
        self.error = nil
        switch error {
        case .getProfileFailed:
            let _ = try await getProfile(forceRefresh: true)
        case .updateProfileLikesFailed(let likedIds):
            let _ = try await updateProfileLikes(likedIds)
        case .toggleLikeFailed(let nftId):
            let _ = try await toggleLikeNFT(nftId: nftId)
        case .updateProfileFailed(let newProfile):
            let _ = try await updateProfile(newProfile)
        }
    }
    
    func clearError() {
        self.error = nil
    }
}

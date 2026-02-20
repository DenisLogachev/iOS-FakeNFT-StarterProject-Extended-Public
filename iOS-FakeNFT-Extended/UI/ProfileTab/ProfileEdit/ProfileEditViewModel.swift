//
//  ProfileEditViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Aida Zhdanova on 28.01.2026.
//

import Foundation

@Observable
@MainActor
final class ProfileEditViewModel {
    private(set) var isSaving: Bool = false
    var draft: ProfileEditDraft

    private var originalDraft: ProfileEditDraft
    private let profileRepo: ProfileRepository

    init(serviceAssembly: ServicesAssembly, profile: Profile) {
        self.profileRepo = serviceAssembly.profileRepo

        let initial = ProfileEditDraft(profile: profile)
        self.originalDraft = initial
        self.draft = initial
    }

    var trimmedName: String {
        draft.name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var hasChanges: Bool { draft != originalDraft }
    var isNameValid: Bool { !trimmedName.isEmpty }
    var canSave: Bool { hasChanges && isNameValid && !isSaving }

    func setAvatarURL(from text: String) {
        let url = parseURL(from: text)
        setAvatarURL(url)
    }

    func setAvatarURL(_ url: URL?) {
        draft.avatarRemoteURL = url
        draft.isAvatarRemoved = (url == nil)
    }

    func removeAvatar() {
        draft.avatarRemoteURL = nil
        draft.isAvatarRemoved = true
    }

    func save() async -> Bool {
        do {
            guard canSave else { return false }
            
            isSaving = true
            defer { isSaving = false }
            
            let currentProfile = try await profileRepo.getProfile(forceRefresh: false)
            let profileToPost = currentProfile.fromDraft(draft)
            let updatedProfile = try await profileRepo.updateProfile(profileToPost)
            
            let updatedDraft = ProfileEditDraft(profile: updatedProfile)
            draft = updatedDraft
            originalDraft = updatedDraft
            
            return true
        } catch {
            debugPrint("Error saving profile: \(error)")
            return false
        }
    }

    private func parseURL(from text: String) -> URL? {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }

        let lower = trimmed.lowercased()
        guard lower != "https://" && lower != "http://" else { return nil }

        let normalized = (lower.hasPrefix("http://") || lower.hasPrefix("https://"))
            ? trimmed
            : "https://" + trimmed

        return URL(string: normalized)
    }
}

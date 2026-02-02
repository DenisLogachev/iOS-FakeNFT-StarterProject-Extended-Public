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
    private let profileId: Int
    private let service: ProfileService
    private let onSaved: @MainActor (Profile) -> Void

    private(set) var isSaving: Bool = false
    var draft: ProfileEditDraft

    private var originalDraft: ProfileEditDraft

    init(
        profileId: Int,
        profile: Profile,
        service: ProfileService,
        onSaved: @escaping @MainActor (Profile) -> Void
    ) {
        self.profileId = profileId
        self.service = service
        self.onSaved = onSaved

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
        guard canSave else { return false }

        isSaving = true
        defer { isSaving = false }

        var normalizedDraft = draft
        normalizedDraft.name = trimmedName

        guard let updated = await service.updateProfile(id: profileId, draft: normalizedDraft) else {
            return false
        }

        let updatedDraft = ProfileEditDraft(profile: updated)
        draft = updatedDraft
        originalDraft = updatedDraft

        onSaved(updated)
        return true
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

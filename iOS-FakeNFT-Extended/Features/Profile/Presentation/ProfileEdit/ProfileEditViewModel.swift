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
    private let service: ProfileService

    private(set) var isSaving: Bool = false
    var draft: ProfileEditDraft

    private let originalDraft: ProfileEditDraft

    init(profile: Profile, service: ProfileService) {
        self.service = service
        self.originalDraft = ProfileEditDraft(profile: profile)
        self.draft = self.originalDraft
    }

    var hasChanges: Bool {
        draft != originalDraft
    }

    func setAvatarURL(from text: String) {
        let url = parseURL(from: text)
        setAvatarURL(url)
    }

    func setAvatarURL(_ url: URL?) {
        draft.avatarRemoteURL = url
        draft.isAvatarRemoved = false
    }

    func removeAvatar() {
        draft.avatarRemoteURL = nil
        draft.isAvatarRemoved = true
    }

    func save() async {
        guard !isSaving else { return }
        isSaving = true
        defer { isSaving = false }
    }

    private func parseURL(from text: String) -> URL? {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }

        if trimmed.hasPrefix("http://") || trimmed.hasPrefix("https://") {
            return URL(string: trimmed)
        } else {
            return URL(string: "https://" + trimmed)
        }
    }
}

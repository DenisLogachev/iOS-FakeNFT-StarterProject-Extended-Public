//
//  ProfileEditDraft.swift
//  iOS-FakeNFT-Extended
//
//  Created by Aida Zhdanova on 28.01.2026.
//

import Foundation

struct ProfileEditDraft: Equatable {
    var name: String
    var description: String
    var website: String

    var avatarRemoteURL: URL?
    var isAvatarRemoved: Bool

    init(profile: Profile) {
        name = profile.name ?? ""
        description = profile.description ?? ""
        website = profile.website ?? ""
        avatarRemoteURL = profile.avatarURL
        isAvatarRemoved = (profile.avatarURL == nil)
    }
}

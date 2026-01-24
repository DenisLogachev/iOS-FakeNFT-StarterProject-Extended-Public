//
//  Profile.swift
//  iOS-FakeNFT-Extended
//
//  Created by Aida Zhdanova on 20.01.2026.
//

import Foundation

struct Profile: Decodable, Sendable {
    let name: String?
    let avatar: String?
    let description: String?
    let website: String?
    let nfts: [String]?
    let likes: [String]?
    let id: String?
}

extension Profile {
    var displayName: String {
        guard let name, !name.isEmpty else {
            return NSLocalizedString("Profile.name.fallback", comment: "")
        }
        return name
    }

    var displayDescription: String {
        guard let description, !description.isEmpty else {
            return NSLocalizedString("Profile.description.fallback", comment: "")
        }
        return description
    }

    var displayWebsite: String? {
        guard let website, !website.isEmpty else { return nil }
        return website
    }

    var nftCount: Int { nfts?.count ?? 0 }
    var likesCount: Int { likes?.count ?? 0 }

    var avatarURL: URL? {
        guard let avatar, let url = URL(string: avatar) else { return nil }
        return url
    }
}

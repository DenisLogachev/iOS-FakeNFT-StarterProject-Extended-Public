//
//  Profile.swift
//  iOS-FakeNFT-Extended
//
//  Created by ANTON ZVERKOV on 06.02.2026.
//

import Foundation

struct Profile: Codable, Hashable {
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
        guard let website else { return nil }
        let trimmed = website.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }

    var nftCount: Int { nfts?.count ?? 0 }
    var likesCount: Int { likes?.count ?? 0 }

    var avatarURL: URL? {
        guard let avatar else { return nil }

        let trimmed = avatar.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }

        return URL(string: trimmed)
    }
}

extension Profile {
    func fromDraft(_ draft: ProfileEditDraft) -> Self {
        .init(
            name: draft.name.trimmingCharacters(in: .whitespacesAndNewlines),
            avatar: draft.isAvatarRemoved ? "" : (draft.avatarRemoteURL?.absoluteString ?? ""),
            description: draft.description,
            website: draft.website,
            nfts: nfts,
            likes: likes,
            id: id)
    }
    
    var data: [String: String] {
        let likes = switch self.likes {
        case .none: "null"
        case .some(let ids):
            ids.isEmpty ? "null" : ids.joined(separator: ",")
        }
        
        return [
            "name": name ?? "no name",
            "description": description ?? "",
            "avatar": avatar ?? "",
            "website": website ?? "",
            "likes": likes
        ]
    }
}

#if DEBUG
extension Profile {
    static let mock: Profile = .init(
        name: "Joaquin Phoenix",
        avatar: "https://picsum.photos/400/400?random=3",
        description: "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям.",
        website: "https://joaquinphoenix.com",
        nfts: ["b3907b86-37c4-4e15-95bc-7f8147a9a660", "de7c0518-6379-443b-a4be-81f5a7655f48"],
        likes: ["b3907b86-37c4-4e15-95bc-7f8147a9a660", "de7c0518-6379-443b-a4be-81f5a7655f48"],
        id: "1"
    )
}
#endif

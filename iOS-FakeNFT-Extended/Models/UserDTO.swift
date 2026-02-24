import Foundation

struct UserDTO: Decodable, Hashable {
    let name: String?
    let avatar: String?
    let description: String?
    let website: String?
    let nfts: [String]?
    let id: String?
}

extension UserDTO {
    var displayName: String {
        guard let name, !name.isEmpty else { return "Unknown" }
        return name
    }

    var displayDescription: String {
        guard let description, !description.isEmpty else { return "" }
        return description
    }

    var displayWebsite: String? {
        guard let website else { return nil }
        let trimmed = website.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }

    var nftCount: Int { nfts?.count ?? 0 }

    var avatarURL: URL? {
        guard let avatar else { return nil }
        let trimmed = avatar.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        return URL(string: trimmed)
    }
}

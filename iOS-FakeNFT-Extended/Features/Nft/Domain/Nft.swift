import Foundation

struct Nft: Decodable, Sendable, Identifiable {
    let id: String
    let name: String?
    let images: [URL]?
    let rating: Int?
    let price: Double?
    let author: String?

    private enum CodingKeys: String, CodingKey {
        case id, name, images, rating, price, author
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)

        name = try container.decodeIfPresent(String.self, forKey: .name)
        rating = try container.decodeIfPresent(Int.self, forKey: .rating)
        price = try container.decodeIfPresent(Double.self, forKey: .price)
        author = try container.decodeIfPresent(String.self, forKey: .author)

        let rawStrings = try container.decodeIfPresent([String].self, forKey: .images)
        let urls = rawStrings?
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .compactMap(URL.init(string:))

        images = urls
    }
}

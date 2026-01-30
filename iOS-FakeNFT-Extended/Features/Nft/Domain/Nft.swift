import Foundation

struct Nft: Decodable, Sendable, Identifiable {
    let id: String
    let name: String
    let images: [URL]
    let rating: Int
    let price: Double
    let author: String

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case images
        case rating
        case price
        case author
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        rating = try container.decode(Int.self, forKey: .rating)
        price = try container.decode(Double.self, forKey: .price)
        author = try container.decode(String.self, forKey: .author)

        let rawStrings = try container.decodeIfPresent([String].self, forKey: .images) ?? []
        images = rawStrings.compactMap {
            URL(string: $0.trimmingCharacters(in: .whitespacesAndNewlines))
        }
    }
}

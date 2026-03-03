import Foundation

struct StatisticsUser: Identifiable, Equatable, Hashable {
    let id: String
    let name: String
    let score: Int
    
    let description: String?
    let website: String?
    let avatarURL: URL?
    let nftIds: [String]
}

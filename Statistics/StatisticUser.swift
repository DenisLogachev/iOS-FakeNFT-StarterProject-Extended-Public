import Foundation

struct StatisticsUser: Identifiable, Equatable, Hashable {
    let id: String
    let name: String
    let score: Int
    let avatarSystemName: String? 
}

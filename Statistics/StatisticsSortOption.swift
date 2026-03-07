import Foundation

enum StatisticsSortOption: String, CaseIterable, Identifiable {
    case byName
    case byScore
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .byName:  return "По имени"
        case .byScore: return "По рейтингу"
        }
    }
}

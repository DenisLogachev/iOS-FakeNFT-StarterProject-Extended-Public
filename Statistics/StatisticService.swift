import Foundation

protocol StatisticsServiceProtocol {
    func loadUsers(sortBy: StatisticsSortOption, page: Int?, size: Int?) async throws -> [UserDTO]
}

final class StatisticsService: StatisticsServiceProtocol {
    private let api: APIClientProtocol
    
    private enum APIConstants {
        static let sortByName = "name"
    }
    
    init(api: APIClientProtocol) {
        self.api = api
    }
    
    func loadUsers(sortBy: StatisticsSortOption, page: Int?, size: Int?) async throws -> [UserDTO] {
        let sortByValue: String? = (sortBy == .byName) ? APIConstants.sortByName : nil
        return try await api.fetchUsers(sortBy: sortByValue, page: page, size: size)
    }
}

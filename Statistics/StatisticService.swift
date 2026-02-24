import Foundation

protocol StatisticsServiceProtocol {
    func loadUsers(sortBy: StatisticsSortOption, page: Int?, size: Int?) async throws -> [UserDTO]
}

final class StatisticsService: StatisticsServiceProtocol {
    private let api: APIClientProtocol

    init(api: APIClientProtocol) {
        self.api = api
    }

    func loadUsers(sortBy: StatisticsSortOption, page: Int?, size: Int?) async throws -> [UserDTO] {
        let sortByValue: String? = (sortBy == .byName) ? "name" : nil
        return try await api.fetchUsers(sortBy: sortByValue, page: page, size: size)
    }
}

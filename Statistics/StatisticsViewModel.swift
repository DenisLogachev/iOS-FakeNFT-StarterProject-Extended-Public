import Foundation
import Observation

@Observable
@MainActor
final class StatisticsViewModel {

    private let service: StatisticsServiceProtocol

    var sortOption: StatisticsSortOption = .byName
    var users: [StatisticsUser] = []

    init(service: StatisticsServiceProtocol) {
        self.service = service
        Task { await loadUsers() }
    }

    func setSort(_ option: StatisticsSortOption) {
        sortOption = option
        Task { await loadUsers() }
    }

    func reload() {
        Task { await loadUsers() }
    }

    // MARK: - Private

    private func loadUsers() async {
        do {
            let dtos = try await service.loadUsers(sortBy: sortOption, page: nil, size: nil)

            users = dtos.map {
                StatisticsUser(
                    id: $0.id ?? UUID().uuidString,
                    name: $0.name ?? "Unknown",
                    score: $0.nfts?.count ?? 0,
                    avatarSystemName: "person.crop.circle.fill"
                )
            }

            applySortLocal()
        } catch {
            debugPrint("❌ Statistics load error:", error)
            users = []
        }
    }

    private func applySortLocal() {
        switch sortOption {
        case .byName:
            users.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        case .byScore:
            users.sort { $0.score > $1.score }
        }
    }
}

import Foundation
import Observation

@Observable
@MainActor
final class StatisticsViewModel {
    
    var sortOption: StatisticsSortOption = .byName
    var users: [StatisticsUser] = []
    
    init() {
        loadMock()
        applySort()
    }
    
    func setSort(_ option: StatisticsSortOption) {
        sortOption = option
        applySort()
    }
    
    // MARK: - Private
    
    private func loadMock() {
        users = [
            .init(id: "1", name: "Alex",      score: 112, avatarSystemName: "person.crop.circle.fill"),
            .init(id: "2", name: "Bill",      score: 98,  avatarSystemName: "person.crop.circle.fill"),
            .init(id: "3", name: "Alla",      score: 72,  avatarSystemName: "person.crop.circle.fill"),
            .init(id: "4", name: "Mads",      score: 71,  avatarSystemName: "person.crop.circle.fill"),
            .init(id: "5", name: "Timothée",  score: 51,  avatarSystemName: "person.crop.circle.fill"),
            .init(id: "6", name: "Lea",       score: 23,  avatarSystemName: "person.crop.circle.fill"),
            .init(id: "7", name: "Eric",      score: 11,  avatarSystemName: "person.crop.circle.fill")
        ]
    }
    
    private func applySort() {
        switch sortOption {
        case .byName:
            users.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        case .byScore:
            users.sort { $0.score > $1.score }
        }
    }
}

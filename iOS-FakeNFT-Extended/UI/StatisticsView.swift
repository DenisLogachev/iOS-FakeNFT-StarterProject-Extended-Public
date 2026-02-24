import SwiftUI

struct StatisticsView: View {
    
    @State private var viewModel: StatisticsViewModel
    @State private var isSortSheetPresented = false
    @State private var selectedUser: StatisticsUser?
    
    init() {
        let api = APIClient(baseURL: Secrets.baseURL)
        let service = StatisticsService(api: api)
        _viewModel = State(wrappedValue: StatisticsViewModel(service: service))
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(Array(viewModel.users.enumerated()), id: \.element.id) { offset, user in
                    StatisticsRowView(index: offset + 1, user: user)
                        .contentShape(Rectangle())
                        .onTapGesture { selectedUser = user }
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20))
                        .listRowBackground(Color.clear)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color.white)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { isSortSheetPresented = true } label: {
                        Image(systemName: "line.3.horizontal")
                    }
                    .tint(.primary)
                    .buttonStyle(.plain)
                    .background(Color.clear)
                }
            }
            .confirmationDialog(
                "Сортировка",
                isPresented: $isSortSheetPresented,
                titleVisibility: .visible
            ) {
                Button(StatisticsSortOption.byName.title) { viewModel.setSort(.byName) }
                Button(StatisticsSortOption.byScore.title) { viewModel.setSort(.byScore) }
                Button("Закрыть", role: .cancel) { }
            }
            .navigationDestination(item: $selectedUser) { user in
                UserCardView(user: user)
            }
        }
    }
}


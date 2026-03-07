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
            content
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button { isSortSheetPresented = true } label: {
                            Image(systemName: "line.3.horizontal")
                        }
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
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        case .empty:
            Text("Нет пользователей")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        case .error(let message):
            VStack(spacing: 12) {
                Text("Ошибка загрузки")
                Text(message)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                Button("Повторить") {
                    viewModel.retry()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        case .content:
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
        }
    }
}

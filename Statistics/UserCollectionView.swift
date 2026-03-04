import Foundation
import SwiftUI

struct UserCollectionView: View {
    
    let title: String
    let nftIds: [String]
    
    @State private var viewModel: UserCollectionViewModel
    init(title: String, nftIds: [String], service: StatisticsServiceProtocol) {
        self.title = title
        self.nftIds = nftIds
        _viewModel = State(initialValue: UserCollectionViewModel(service: service, nftIds: nftIds))
    }
    
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        Group {
            switch viewModel.state {
                
            case .loading:
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            case .empty:
                Text("Коллекция пуста")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            case .error(let message):
                VStack(spacing: 12) {
                    Text("Ошибка загрузки")
                    Text(message)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Button("Повторить") {
                        viewModel.retry()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            case .content(let nfts):
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 28) {
                        ForEach(nfts, id: \.id) { nft in
                            NFTCardView(nft: nft)
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

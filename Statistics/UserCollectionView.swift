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
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(0..<6, id: \.self) { _ in
                    VStack(alignment: .leading, spacing: 6) {
                        RoundedRectangle(cornerRadius: 12)
                            .frame(height: 92)
                            .foregroundStyle(.gray.opacity(0.25))
                        
                        Text("NFT name")
                            .font(.subheadline)
                            .bold()
                        
                        Text("1.78 ETH")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding()
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

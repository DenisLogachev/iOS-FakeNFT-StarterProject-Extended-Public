import Foundation
import Observation

@Observable
@MainActor
final class UserCollectionViewModel {
    
    enum State {
        case loading
        case content([NFTItem])
        case empty
        case error(String)
    }
    
    private let service: StatisticsServiceProtocol
    private let nftIds: [String]
    
    var state: State = .loading
    
    init(service: StatisticsServiceProtocol, nftIds: [String]) {
        self.service = service
        self.nftIds = nftIds
        Task { await loadNFTs() }
    }
    
    func retry() {
        Task { await loadNFTs() }
    }
    
    private func loadNFTs() async {
        state = .loading
        
        do {
            let nfts = try await service.loadNFTs(ids: nftIds)
            
            if nfts.isEmpty {
                state = .empty
            } else {
                state = .content(nfts)
            }
            
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}

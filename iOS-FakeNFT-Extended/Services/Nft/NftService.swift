import Foundation

protocol NftService: Sendable {
    func loadNft(id: String, forceRefresh: Bool) async throws -> Nft
}

extension NftService {
    func loadNft(id: String) async throws -> Nft {
        try await loadNft(id: id, forceRefresh: false)
    }
}

@MainActor
final class NftServiceImpl: NftService {

    private let networkClient: NetworkClient
    private let storage: NftStorage

    init(networkClient: NetworkClient, storage: NftStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }

    func loadNft(id: String, forceRefresh: Bool) async throws -> Nft {
        if !forceRefresh, let cachedNft = await storage.getNft(with: id) {
            return cachedNft
        }

        let request = NFTRequest(id: id)
        let nft: Nft = try await networkClient.send(request: request)
        await storage.saveNft(nft)
        return nft
    }
}

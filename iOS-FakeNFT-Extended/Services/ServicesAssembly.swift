import Foundation

@Observable
@MainActor
final class ServicesAssembly {
    private let apiClient: APIClientProtocol
    
    let cartRepo: CartRepository
    let collectionsRepo: CollectionsRepository
    let currenciesRepo: CurrenciesRepo
    let nftRepo: NFTsRepository
    let profileRepo: ProfileRepository
    
    init(client: APIClientProtocol) {
        self.apiClient = client
        
        self.cartRepo = CartRepo(api: client)
        self.collectionsRepo = CollectionsRepo(api: client)
        self.currenciesRepo = CurrenciesRepo(api: client)
        self.nftRepo = NFTRepo(api: client)
        self.profileRepo = ProfileRepo(api: client)
    }
    
    var hasAnyError: Bool {
        cartRepo.error != nil ||
        collectionsRepo.error != nil ||
        nftRepo.error != nil ||
        profileRepo.error != nil ||
        currenciesRepo.error != nil
    }
    
    func clearErrors() {
        cartRepo.clearError()
        collectionsRepo.clearError()
        nftRepo.clearError()
        profileRepo.clearError()
        currenciesRepo.clearError()
    }
    
    func retry() async {
        do {
            if let error = cartRepo.error { try await cartRepo.retryAfter(error: error) }
            if let error = collectionsRepo.error { try await collectionsRepo.retryAfter(error: error) }
            if let error = nftRepo.error { try await nftRepo.retryAfter(error: error) }
            if let error = profileRepo.error { try await profileRepo.retryAfter(error: error) }
            if let error = currenciesRepo.error { try await currenciesRepo.retryAfter(error: error) }
        } catch {
            print("Retry failed: \(error)")
        }
    }
}

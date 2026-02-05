import Foundation

@Observable
@MainActor
final class ServicesAssembly {
    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
    private let profileStorage: ProfileStorage
    private let myNftsStoreInternal: MyNftsStore

    let nftService: NftService
    let profileService: ProfileService
    let nftLikesService: NftLikesService

    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage,
        profileStorage: ProfileStorage,
        myNftsStore: MyNftsStore = MyNftsStoreImpl()
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
        self.profileStorage = profileStorage
        self.myNftsStoreInternal = myNftsStore

        let profileService = ProfileServiceImpl(networkClient: networkClient, storage: profileStorage)

        self.profileService = profileService
        self.nftService = NftServiceImpl(networkClient: networkClient, storage: nftStorage)
        self.nftLikesService = NftLikesServiceImpl(profileService: profileService)
    }

    var myNftsStore: MyNftsStore { myNftsStoreInternal }

    var currencyService: CurrencyService {
        CurrencyServiceImpl(networkClient: networkClient)
    }

    var orderService: OrderService {
        OrderServiceImpl(networkClient: networkClient)
    }
}

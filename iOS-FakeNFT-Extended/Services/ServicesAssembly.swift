import Foundation

@Observable
@MainActor
final class ServicesAssembly {
    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
    private let profileStorage: ProfileStorage

    private let myNftsStore: MyNftsStore

    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage,
        profileStorage: ProfileStorage,
        myNftsStore: MyNftsStore = MyNftsStoreImpl()
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
        self.profileStorage = profileStorage
        self.myNftsStore = myNftsStore
    }

    var nftService: NftService {
        NftServiceImpl(networkClient: networkClient, storage: nftStorage)
    }

    var profileService: ProfileService {
        ProfileServiceImpl(networkClient: networkClient, storage: profileStorage)
    }

    var myNftsStoreService: MyNftsStore { myNftsStore }
}

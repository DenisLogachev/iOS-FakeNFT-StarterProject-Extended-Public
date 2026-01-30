//
//  NFTCollection.swift
//  iOS-FakeNFT-Extended
//
//  Created by ANTON ZVERKOV on 28.01.2026.
//

import Foundation

struct NFTCollection: Decodable, Identifiable, Hashable {
    let createdAt: String
    let name: String
    let cover: String
    let nfts: [String]
    let description: String
    let author: String
    let website: String
    let id: String
    
    var uniqueNfts: [String] { nfts.unique() }
}

#if DEBUG
extension NFTCollection {
    static let mockCollections: [NFTCollection] = [
        NFTCollection(
            createdAt: "2023-10-01T12:00:00Z",
            name: "Nudes",
            cover: "https://picsum.photos/600/600?random=1",
            nfts: ["nft1", "nft2", "nft3", "nft4", "nft5", "nft6", "nft7"],
            description: "Персиковый — как облака над закатным солнцем в океане. В этой коллекции совмещены трогательная нежность и живая игривость сказочных зефирных зверей.",
            author: "Praktikum Labs",
            website: "https://praktonudes.com",
            id: "c1"
        ),
        NFTCollection(
            createdAt: "2023-10-02T12:00:00Z",
            name: "Boobs",
            cover: "https://picsum.photos/600/600?random=2",
            nfts: ["nft8"],
            description: "Exclusive boobs community",
            author: "Friendly community",
            website: "https://boredpraktikumstudent.com",
            id: "c2"
        )
    ]
}
#endif

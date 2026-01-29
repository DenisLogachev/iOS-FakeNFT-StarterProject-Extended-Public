//
//  NFTItem.swift
//  iOS-FakeNFT-Extended
//
//  Created by ANTON ZVERKOV on 28.01.2026.
//

import Foundation

struct NFTItem: Decodable, Identifiable, Hashable {
    let createdAt: String
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Double
    let author: String
    let website: String
    let id: String
    
    var priceString: String {
        String(format: "%.2f", price)
    }
}

#if DEBUG
extension NFTItem {
    static let mockNFTs: [NFTItem] = [
        NFTItem(
            createdAt: "1776-08-02T12:00:00Z",
            name: "Declaration of Independence",
            images: [
                "https://picsum.photos/400/400?random=3",
                "https://picsum.photos/400/400?random=4"
            ],
            rating: 2,
            description: "Some fancy historical nft",
            price: 50.20,
            author: "Arnold Schwarzenegger",
            website: "https://www.archives.gov",
            id: "nft1"
        ),
        NFTItem(
            createdAt: "2077-10-02T12:00:00Z",
            name: "CyberPunk",
            images: [
                "https://picsum.photos/400/400?random=5",
                "https://picsum.photos/400/400?random=6"
            ],
            rating: 5,
            description: "Best game ever made",
            price: 999.99,
            author: "CD Project Red",
            website: "https://www.cyberpunk.net",
            id: "nft2"
        ),
        NFTItem(
            createdAt: "1776-08-02T12:00:00Z",
            name: "Declaration of Independence",
            images: [
                "https://picsum.photos/400/400?random=3",
                "https://picsum.photos/400/400?random=4"
            ],
            rating: 3,
            description: "Some fancy historical nft",
            price: 50.20,
            author: "Arnold Schwarzenegger",
            website: "https://www.archives.gov",
            id: "nft3"
        ),
        NFTItem(
            createdAt: "2077-10-02T12:00:00Z",
            name: "CyberPunk",
            images: [
                "https://picsum.photos/400/400?random=5",
                "https://picsum.photos/400/400?random=6"
            ],
            rating: 4,
            description: "Best game ever made",
            price: 999.99,
            author: "CD Project Red",
            website: "https://www.cyberpunk.net",
            id: "nft4"
        ),
        NFTItem(
            createdAt: "1776-08-02T12:00:00Z",
            name: "Declaration of Independence",
            images: [
                "https://picsum.photos/400/400?random=3",
                "https://picsum.photos/400/400?random=4"
            ],
            rating: 0,
            description: "Some fancy historical nft",
            price: 50.20,
            author: "Arnold Schwarzenegger",
            website: "https://www.archives.gov",
            id: "nft5"
        ),
        NFTItem(
            createdAt: "2077-10-02T12:00:00Z",
            name: "CyberPunk",
            images: [
                "https://picsum.photos/400/400?random=5",
                "https://picsum.photos/400/400?random=6"
            ],
            rating: 5,
            description: "Best game ever made",
            price: 999.99,
            author: "CD Project Red",
            website: "https://www.cyberpunk.net",
            id: "nft6"
        ),
        NFTItem(
            createdAt: "1776-08-02T12:00:00Z",
            name: "Declaration of Independence",
            images: [
                "https://picsum.photos/400/400?random=3",
                "https://picsum.photos/400/400?random=4"
            ],
            rating: 2,
            description: "Some fancy historical nft",
            price: 50.20,
            author: "Arnold Schwarzenegger",
            website: "https://www.archives.gov",
            id: "nft7"
        ),
        NFTItem(
            createdAt: "2077-10-02T12:00:00Z",
            name: "CyberPunk",
            images: [
                "https://picsum.photos/400/400?random=5",
                "https://picsum.photos/400/400?random=6"
            ],
            rating: 3,
            description: "Best game ever made",
            price: 999.99,
            author: "CD Project Red",
            website: "https://www.cyberpunk.net",
            id: "nft8"
        ),
    ]
}
#endif

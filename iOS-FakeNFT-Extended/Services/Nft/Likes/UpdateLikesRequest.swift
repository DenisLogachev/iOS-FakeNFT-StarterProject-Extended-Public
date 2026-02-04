//
//  UpdateLikesRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Aida Zhdanova on 02.02.2026.
//

import Foundation

struct UpdateLikesRequest: NetworkRequest {
    let id: Int
    let likes: [String]?

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(id)")
    }

    var httpMethod: HttpMethod { .put }

    var headers: [String: String] {
        ["Content-Type": "application/x-www-form-urlencoded"]
    }

    var body: Data? {
        if let likes, !likes.isEmpty {
            let items = likes.map { (key: "likes", value: $0) }
            return FormURLEncoder.encode(items: items)
        } else {
            return FormURLEncoder.encode(items: [(key: "likes", value: "null")])
        }
    }
}

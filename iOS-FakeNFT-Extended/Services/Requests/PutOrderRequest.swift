//
//  PutOrderRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Denis on 28/01/2026.
//

import Foundation

struct PutOrderRequest: NetworkRequest {
    let nftIds: [String]
    
    var httpMethod: HttpMethod {
        .put
    }
    
    var endpoint: URL? {
        URL(string: RequestConstants.baseURL + "/api/v1/orders/1")
    }
    
    var contentType: String? {
        "application/x-www-form-urlencoded"
    }
    
    var dto: Encodable? {
        OrderURLEncodedDTO(nftIds: nftIds)
    }
}

private struct OrderURLEncodedDTO: URLEncodable, Encodable {
    let nftIds: [String]

    func urlEncodedData() -> Data? {
        let components = nftIds.map {
            "nfts=\($0.addingPercentEncoding(withAllowedCharacters: .formValueAllowed) ?? $0)"
        }
        return components.joined(separator: "&").data(using: .utf8)
    }
    
    func encode(to encoder: Encoder) throws {}
}

private extension CharacterSet {
    static let formValueAllowed: CharacterSet = {
        var set = CharacterSet.urlQueryAllowed
        set.remove(charactersIn: "&=")
        return set
    }()
}

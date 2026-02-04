//
//  FormURLEncoder.swift
//  iOS-FakeNFT-Extended
//
//  Created by Aida Zhdanova on 29.01.2026.
//

import Foundation

enum FormURLEncoder {

    static func encode(_ parameters: [String: String]) -> Data {
        encode(
            items: parameters.map { (key: $0.key, value: $0.value) }
        )
    }

    static func encode(items: [(key: String, value: String)]) -> Data {
        encodeInternal(items)
    }

    private static func encodeInternal(
        _ items: [(key: String, value: String)]
    ) -> Data {
        let allowed = CharacterSet
            .urlQueryAllowed
            .subtracting(CharacterSet(charactersIn: "&+="))

        let query = items
            .map { key, value in
                let encodedKey = key.addingPercentEncoding(withAllowedCharacters: allowed) ?? key
                let encodedValue = value.addingPercentEncoding(withAllowedCharacters: allowed) ?? value
                return "\(encodedKey)=\(encodedValue)"
            }
            .joined(separator: "&")

        return Data(query.utf8)
    }
}

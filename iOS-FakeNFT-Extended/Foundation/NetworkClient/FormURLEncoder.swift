//
//  FormURLEncoder.swift
//  iOS-FakeNFT-Extended
//
//  Created by Aida Zhdanova on 29.01.2026.
//

import Foundation

enum FormURLEncoder {
    static func encode(_ parameters: [String: String]) -> Data {
        let allowed = CharacterSet.urlQueryAllowed.subtracting(CharacterSet(charactersIn: "&+="))

        let query = parameters
            .map { key, value in
                let encodedKey = key.addingPercentEncoding(withAllowedCharacters: allowed) ?? key
                let encodedValue = value.addingPercentEncoding(withAllowedCharacters: allowed) ?? value
                return "\(encodedKey)=\(encodedValue)"
            }
            .joined(separator: "&")

        return Data(query.utf8)
    }
}

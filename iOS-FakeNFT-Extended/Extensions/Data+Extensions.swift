//
//  Data+Extensions.swift
//  iOS-FakeNFT-Extended
//
//  Created by ANTON ZVERKOV on 06.02.2026.
//

import Foundation

extension Data {
    static func from(params: [String : String]) -> Data? {
        params
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            .flatMap { Data($0.utf8) }
    }
}

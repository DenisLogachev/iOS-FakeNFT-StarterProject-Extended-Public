//
//  ProfileRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Aida Zhdanova on 20.01.2026.
//

import Foundation

struct ProfileRequest: NetworkRequest {
    let id: Int
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(id)")
    }
}

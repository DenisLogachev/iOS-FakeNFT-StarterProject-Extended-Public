//
//  ProfileUpdateRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Aida Zhdanova on 29.01.2026.
//

import Foundation

struct ProfileUpdateRequest: NetworkRequest {
    let id: Int
    let draft: ProfileEditDraft

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(id)")
    }

    var httpMethod: HttpMethod { .put }

    var headers: [String : String] {
        ["Content-Type": "application/x-www-form-urlencoded"]
    }

    var body: Data? {
        let avatarValue: String
        if draft.isAvatarRemoved {
            avatarValue = ""
        } else {
            avatarValue = draft.avatarRemoteURL?.absoluteString ?? ""
        }

        let parameters: [String: String] = [
            "name": draft.name,
            "description": draft.description,
            "avatar": avatarValue,
            "website": draft.website
        ]

        return FormURLEncoder.encode(parameters)
    }
}

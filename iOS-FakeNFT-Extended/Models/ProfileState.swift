//
//  ProfileState.swift
//  iOS-FakeNFT-Extended
//
//  Created by ANTON ZVERKOV on 07.02.2026.
//

import Foundation

enum ProfileState: Sendable {
    case idle
    case loaded(Profile)
    
    var isLoading: Bool {
        switch self {
        case .idle: true
        case .loaded: false
        }
    }
}

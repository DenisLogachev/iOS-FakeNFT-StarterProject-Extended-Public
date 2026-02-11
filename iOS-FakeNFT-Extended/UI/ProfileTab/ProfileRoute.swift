//
//  ProfileRoute.swift
//  iOS-FakeNFT-Extended
//
//  Created by Aida Zhdanova on 20.01.2026.
//

import Foundation

enum ProfileRoute: Hashable {
    case myNfts(profile: Profile)
    case favourites(profile: Profile)
    case editProfile(profile: Profile)
    case website(url: URL)
}

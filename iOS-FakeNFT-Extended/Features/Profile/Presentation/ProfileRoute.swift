//
//  ProfileRoute.swift
//  iOS-FakeNFT-Extended
//
//  Created by Aida Zhdanova on 20.01.2026.
//

import Foundation

enum ProfileRoute: Hashable {
    case myNfts
    case favourites
    case editProfile(profileId: Int)
    case website(URL)
}

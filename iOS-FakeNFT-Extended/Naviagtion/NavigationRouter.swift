//
//  NavigationRouter.swift
//  iOS-FakeNFT-Extended
//
//  Created by ANTON ZVERKOV on 28.01.2026.
//

import SwiftUI

@MainActor
@Observable
final class NavigationRouter {
    var path = NavigationPath()
    
    enum NavDestination: Hashable {
        case collection(NFTCollection)
        case author(String)
    }
    
    func navigate(to destination: NavDestination) {
        path.append(destination)
    }
    
    func navigateBack() {
        path.removeLast()
    }
    
    func navigateToRoot() {
        path.removeLast(path.count)
    }
}

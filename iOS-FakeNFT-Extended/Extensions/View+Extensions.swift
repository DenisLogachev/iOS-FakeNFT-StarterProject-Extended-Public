//
//  View+Extensions.swift
//  iOS-FakeNFT-Extended
//
//  Created by ANTON ZVERKOV on 29.01.2026.
//

import SwiftUI

extension View {
    func hiddenWhen(_ condition: Bool) -> some View {
        opacity(condition ? 0 : 1)
    }
}

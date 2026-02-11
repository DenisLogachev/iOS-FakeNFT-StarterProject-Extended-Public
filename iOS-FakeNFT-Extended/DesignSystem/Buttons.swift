//
//  Buttons.swift
//  iOS-FakeNFT-Extended
//
//  Created by Denis on 25/01/2026.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    let height: CGFloat
    let foregroundColor: Color
    
    init(
        height: CGFloat = LayoutConstants.buttonHeightLarge,
        foregroundColor: Color = .ypWhite
    ) {
        self.height = height
        self.foregroundColor = foregroundColor
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title3SemiBold)
            .foregroundStyle(foregroundColor)
            .frame(height: height)
            .frame(maxWidth: .infinity)
            .background(.ypBlack)
            .clipShape(RoundedRectangle(cornerRadius: LayoutConstants.cornerRadius))
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {
    static var primary: PrimaryButtonStyle { PrimaryButtonStyle() }
    
    static func primary(height: CGFloat) -> PrimaryButtonStyle {
        PrimaryButtonStyle(height: height)
    }
    
    static func primary(height: CGFloat, foregroundColor: Color) -> PrimaryButtonStyle {
        PrimaryButtonStyle(height: height, foregroundColor: foregroundColor)
    }
}

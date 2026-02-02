//
//  NFTPriceText.swift
//  iOS-FakeNFT-Extended
//
//  Created by Aida Zhdanova on 02.02.2026.
//

import SwiftUI

struct NFTPriceText: View {
    let price: Double?
    let fontSize: CGFloat
    let fontWeight: Font.Weight

    init(
        price: Double?,
        fontSize: CGFloat = 13,
        fontWeight: Font.Weight = .regular
    ) {
        self.price = price
        self.fontSize = fontSize
        self.fontWeight = fontWeight
    }

    var body: some View {
        Text("\(formatPrice(price ?? 0)) ETH")
            .font(.system(size: fontSize, weight: fontWeight))
            .foregroundStyle(.ypBlack)
            .lineLimit(1)
    }

    private func formatPrice(_ value: Double) -> String {
        Self.priceFormatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }

    private static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.decimalSeparator = ","
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        return formatter
    }()
}

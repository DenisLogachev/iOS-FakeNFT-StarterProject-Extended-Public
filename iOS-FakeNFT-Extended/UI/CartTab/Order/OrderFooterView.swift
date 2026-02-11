//
//  OrderFooterView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Denis on 25/01/2026.
//

import SwiftUI

struct OrderFooterView: View {
    let nftCount: Int
    let totalPrice: Double
    let onPaymentTap: () -> Void
    
    var body: some View {
        HStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 2) {
                Text("\(nftCount) NFT")
                    .font(.appCalloutRegular)
                    .foregroundStyle(.primary)
                
                Text(priceText)
                    .font(.title3SemiBold)
                    .foregroundStyle(.ypGreen)
            }
            
            Spacer()
            
            Button(action: onPaymentTap) {
                Text(String(localized: "Order.payment.button"))
            }
            .buttonStyle(.primary(height: LayoutConstants.buttonHeightSmall))
        }
        .padding(.horizontal, LayoutConstants.paddingStandard)
        .padding(.vertical, LayoutConstants.paddingStandard)
        .background(.ypLightGray)
        .clipShape(RoundedRectangle(cornerRadius: LayoutConstants.cornerRadius))
    }
    
    private var priceText: String {
        String(format: "%.2f", totalPrice) + " ETH"
    }
}

// MARK: - Preview
#Preview {
    OrderFooterView(
        nftCount: 3,
        totalPrice: 4.6,
        onPaymentTap: {}
    )
}

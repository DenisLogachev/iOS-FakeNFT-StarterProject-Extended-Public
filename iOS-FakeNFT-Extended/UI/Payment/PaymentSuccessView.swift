//
//  PaymentSuccessView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Denis on 25/01/2026.
//

import SwiftUI

struct PaymentSuccessView: View {
    let onBackToCart: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 20) {
                Image.digital_art
                    .resizable()
                    .frame(width: 278, height: 278)
                
                Text(String(localized: "Payment.success.title"))
                    .font(.title2SemiBold)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
            
            Button(action: {
                onBackToCart()
                dismiss()
            }) {
                Text(String(localized: "Payment.success.backToCart"))
            }
            .buttonStyle(.primary)
            .padding(.horizontal, LayoutConstants.paddingStandard)
            .padding(.bottom, LayoutConstants.paddingStandard)
        }
    }
}

// MARK: - Preview
#Preview {
    PaymentSuccessView(onBackToCart: {})
        .padding()
}

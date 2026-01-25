//
//  CurrencySelectionFooterView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Denis on 25/01/2026.
//

import SwiftUI

struct CurrencySelectionFooterView: View {
    let onTermsOfUseTap: () -> Void
    let onPayTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(String(localized: "CurrencySelection.agreementText"))
                .font(.footnoteRegular)
                .foregroundStyle(.primary)
            
            Button(action: onTermsOfUseTap) {
                Text(String(localized: "CurrencySelection.termsOfUseLink"))
                    .font(.footnoteRegular)
                    .foregroundStyle(.ypBlue)
            }
            .padding(.bottom, 8)
            
            Button(action: onPayTap) {
                Text(String(localized: "CurrencySelection.payButton"))
            }
            .buttonStyle(.primary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(.ypLightGray)
        .clipShape(RoundedRectangle(cornerRadius: LayoutConstants.cornerRadius))
        .padding(.bottom, 16)
    }
}

// MARK: - Preview
#Preview {
    CurrencySelectionFooterView(
        onTermsOfUseTap: {},
        onPayTap: {}
    )
}

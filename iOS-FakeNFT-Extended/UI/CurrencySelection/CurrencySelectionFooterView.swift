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
            .padding(.bottom, LayoutConstants.paddingSmall)
            
            Button(action: onPayTap) {
                Text(String(localized: "CurrencySelection.payButton"))
            }
            .buttonStyle(.primary)
        }
        .padding(.horizontal, LayoutConstants.paddingStandard)
        .padding(.vertical, LayoutConstants.paddingStandard)
        .background(.ypLightGray)
        .clipShape(RoundedRectangle(cornerRadius: LayoutConstants.cornerRadius))
        .padding(.bottom, LayoutConstants.paddingStandard)
    }
}

// MARK: - Preview
#Preview {
    CurrencySelectionFooterView(
        onTermsOfUseTap: {},
        onPayTap: {}
    )
}

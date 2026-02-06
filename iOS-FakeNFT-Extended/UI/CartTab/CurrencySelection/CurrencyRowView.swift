//
//  CurrencyRowView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Denis on 25/01/2026.
//

import SwiftUI

struct CurrencyRowView: View {
    let currency: Currency
    let isSelected: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            if let url = URL(string: currency.image) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .tint(.white)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    case .failure:
                        Image(systemName: "dollarsign.circle.fill")
                            .foregroundStyle(.white)
                    @unknown default:
                        EmptyView()
                    }
                }
                .padding(2.25)
                .frame(width: 36, height: 36)
                .background(Color.black)
                .clipShape(RoundedRectangle(cornerRadius: 6))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(currency.title)
                    .font(.footnoteRegular)
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                
                Text(currency.name)
                    .font(.footnoteRegular)
                    .foregroundStyle(.ypGreen)
                    .lineLimit(1)
            }
            
            Spacer()
        }
        .padding(.vertical, 5)
        .padding(.horizontal, LayoutConstants.paddingMedium)
        .background(.ypLightGray)
        .clipShape(RoundedRectangle(cornerRadius: LayoutConstants.cornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: LayoutConstants.cornerRadius)
                .stroke(isSelected ? Color.black : Color.clear, lineWidth: 1)
        )
    }
}

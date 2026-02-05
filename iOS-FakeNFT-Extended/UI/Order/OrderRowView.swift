//
//  OrderRowView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Denis on 25/01/2026.
//

import SwiftUI

struct OrderRowView: View {
    let item: OrderItem
    let onDeleteTap: () -> Void
    
    var body: some View {
        HStack(spacing: 20) {
            NftImageView(
                imageURL: item.nft.images?.first,
                nftId: item.nft.id
            )
            
            VStack(alignment: .leading, spacing: 0) {
                Text(item.nft.name ?? "")
                    .font(.title3SemiBold)
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                
                HStack(spacing: 2) {
                    ForEach(0..<5, id: \.self) { index in
                        (index < (item.nft.rating ?? 0) ? Image.icStarSelected : Image.icStarUnselected)
                            .resizable()
                            .renderingMode(.original)
                            .frame(width: 12, height: 12)
                    }
                }
                .padding(.top, 4)
                
                Text(String(localized: "Order.row.price"))
                    .font(.footnoteRegular)
                    .foregroundStyle(.primary)
                    .padding(.top, 12)
                
                Text(priceText)
                    .font(.title3SemiBold)
                    .foregroundStyle(.primary)
                    .padding(.top, 2)
            }
            
            Spacer()
            
            Button(action: onDeleteTap) {
                Image.icBasketOut
                    .renderingMode(.original)
                    .frame(width: 40, height: 40)
                    .contentShape(Rectangle())
            }
        }
        .padding(.vertical, LayoutConstants.paddingSmall)
        .padding(.horizontal, LayoutConstants.paddingStandard)
    }
    
    private var priceText: String {
        "\(item.price.formattedPrice()) ETH"
    }
}

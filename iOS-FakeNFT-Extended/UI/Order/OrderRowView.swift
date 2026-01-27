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
                imageURL: item.nft.images.first,
                nftId: item.nft.id
            )
            
            VStack(alignment: .leading, spacing: 0) {
                Text(nftName)
                    .font(.title3SemiBold)
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                
                HStack(spacing: 2) {
                    ForEach(0..<5) { index in
                        (index < rating ? Image.icStarSelected : Image.icStarUnselected)
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

// MARK: - Display Helpers
extension OrderRowView {
    private var nftName: String {
        let number = abs(item.nft.id.hashValue) % 1000 + 1
        return "NFT #\(number)"
    }
    
    private var rating: Int {
        abs(item.nft.id.hashValue) % 5 + 1
    }
}

// MARK: - Preview
#Preview("Single Item", traits: .sizeThatFitsLayout) {
    OrderRowView(
        item: OrderItem(
            nft: Nft(
                id: "preview-nft-123",
                images: [URL(string: "https://picsum.photos/200/200?random=1")!]
            ),
            price: Decimal(string: "1.5")!
        ),
        onDeleteTap: {}
    )
    .padding()
}

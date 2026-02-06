//
//  DeleteConfirmationView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Denis on 25/01/2026.
//

import SwiftUI

struct DeleteConfirmationView: View {
    let item: NFTItem
    @Binding var isPresented: Bool
    let onDelete: () -> Void
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
                .onTapGesture {
                    isPresented = false
                }
            
            VStack(spacing: 20) {
                NftImageView(
                    imageURL: item.images.first ?? "",
                    nftId: item.id
                )
                
                Text(String(localized: "Order.delete.confirmation"))
                    .font(.footnoteRegular)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 41)
                
                HStack(spacing: 8) {
                    Button(action: onDelete) {
                        Text(String(localized: "Order.delete.confirm"))
                    }
                    .buttonStyle(.primary(height: LayoutConstants.buttonHeightSmall, foregroundColor: .ypRed))
                    
                    Button(action: { isPresented = false }) {
                        Text(String(localized: "Order.delete.cancel"))
                    }
                    .buttonStyle(.primary(height: LayoutConstants.buttonHeightSmall))
                }
            }
            .padding(.horizontal, 56)
        }
    }
}

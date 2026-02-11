//
//  EmptyCartView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Denis on 25/01/2026.
//

import SwiftUI

struct EmptyCartView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Text(String(localized: "Order.empty.title"))
                .font(.title3SemiBold)
                .foregroundStyle(.primary)
            
            Spacer()
        }
    }
}

#Preview {
    EmptyCartView()
        .padding()
}

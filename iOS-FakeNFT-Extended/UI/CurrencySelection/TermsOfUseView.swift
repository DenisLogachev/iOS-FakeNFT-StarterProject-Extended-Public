//
//  TermsOfUseView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Denis on 25/01/2026.
//

import SwiftUI
import WebKit

struct TermsOfUseView: View {
    @Binding var isPresented: Bool
    @State private var isLoading = true
    
    private static let termsOfUseURL = URL(string: "https://yandex.ru/legal/practicum_termsofuse")!
    
    var body: some View {
        NavigationStack {
            ZStack {
                WebView(url: Self.termsOfUseURL, isLoading: $isLoading)
                
                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color(.systemBackground))
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        isPresented = false
                    }) {
                        Text(NSLocalizedString("CurrencySelection.close", comment: ""))
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    TermsOfUseView(isPresented: .constant(true))
}

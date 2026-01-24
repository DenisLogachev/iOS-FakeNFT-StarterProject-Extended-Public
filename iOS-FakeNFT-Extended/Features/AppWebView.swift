//
//  AppWebView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Aida Zhdanova on 22.01.2026.
//

import SwiftUI

struct AppWebView: View {
    let url: URL
    @Environment(\.dismiss) private var dismiss
    @State private var isLoading = true

    var body: some View {
        ZStack {
            WebView(url: url, isLoading: $isLoading)
                .ignoresSafeArea()
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(.icBackward)
                        }
                    }
                }

            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

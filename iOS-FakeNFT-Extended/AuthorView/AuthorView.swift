//
//  AuthorView.swift
//  iOS-FakeNFT-Extended
//
//  Created by ANTON ZVERKOV on 29.01.2026.
//

import SwiftUI

struct AuthorView: View {
    @State private var isLoading: Bool = false
    
    var body: some View {
        ZStack {
            if let url = URL(string: "https://practicum.yandex.ru") {
                WebView(isLoading: $isLoading, url: url)
            }
            BlobsView().hiddenWhen(isLoading)
        }
        .ignoresSafeArea()
        .animation(.easeInOut(duration: 1), value: isLoading)
    }
}

#Preview {
    AuthorView()
}

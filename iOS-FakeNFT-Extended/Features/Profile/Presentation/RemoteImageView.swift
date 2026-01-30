//
//  RemoteImageView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Aida Zhdanova on 29.01.2026.
//

import SwiftUI

struct RemoteImageView<Placeholder: View>: View {
    let url: URL?
    @ViewBuilder let placeholder: () -> Placeholder

    @State private var uiImage: UIImage?
    @State private var isLoading = false

    var body: some View {
        Group {
            if let uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                ZStack {
                    placeholder()

                    ProgressView()
                }
            }
        }
        .task(id: url?.absoluteString) {
            await load()
        }
    }

    private func load() async {
        guard !isLoading else { return }
        guard let url else {
            await MainActor.run { uiImage = nil }
            return
        }

        isLoading = true
        defer { isLoading = false }

        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.timeoutInterval = 20

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let http = response as? HTTPURLResponse,
                  200..<300 ~= http.statusCode,
                  let image = UIImage(data: data) else {
                await MainActor.run { uiImage = nil }
                return
            }
            await MainActor.run { uiImage = image }
        } catch {
            await MainActor.run { uiImage = nil }
        }
    }
}

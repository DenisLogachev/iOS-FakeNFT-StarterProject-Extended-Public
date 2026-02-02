//
//  RemoteImageView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Aida Zhdanova on 29.01.2026.
//

import SwiftUI

enum RemoteImageLoadState: Sendable {
    case idle
    case loading
    case success
    case failure
}

struct RemoteImageView<Placeholder: View>: View {
    let url: URL?
    @ViewBuilder let placeholder: () -> Placeholder

    let showsLoader: Bool
    let onStateChange: (@Sendable (RemoteImageLoadState) -> Void)?

    @State private var uiImage: UIImage?
    @State private var isLoading = false

    init(
        url: URL?,
        showsLoader: Bool = true,
        onStateChange: (@Sendable (RemoteImageLoadState) -> Void)? = nil,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.url = url
        self.showsLoader = showsLoader
        self.onStateChange = onStateChange
        self.placeholder = placeholder
    }

    var body: some View {
        ZStack {
            if let uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .transition(.opacity)
            } else {
                ZStack {
                    placeholder()
                        .transition(.opacity)

                    if showsLoader, isLoading {
                        ProgressView()
                            .transition(.opacity)
                    }
                }
            }
        }
        .animation(.easeInOut(duration: 0.2), value: uiImage != nil)
        .animation(.easeInOut(duration: 0.2), value: isLoading)
        .task(id: url?.absoluteString) {
            await load()
        }
    }

    private func load() async {
        guard !isLoading else { return }

        await MainActor.run {
            uiImage = nil
        }
        onStateChange?(.idle)

        guard let url else {
            onStateChange?(.failure)
            return
        }

        isLoading = true
        onStateChange?(.loading)
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
                onStateChange?(.failure)
                return
            }

            await MainActor.run { uiImage = image }
            onStateChange?(.success)
        } catch {
            await MainActor.run { uiImage = nil }
            onStateChange?(.failure)
        }
    }
}

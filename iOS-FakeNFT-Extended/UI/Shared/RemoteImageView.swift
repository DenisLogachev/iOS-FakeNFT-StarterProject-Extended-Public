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
    let url: String
    @ViewBuilder let placeholder: () -> Placeholder

    let showsLoader: Bool
    let onStateChange: (@Sendable (RemoteImageLoadState) -> Void)?

    @State private var uiImage: UIImage?
    @State private var isLoading = false
    @State private var loadedURLString: String?

    init(
        url: String,
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
                placeholder()
                    .transition(.opacity)
            }

            if showsLoader, isLoading {
                ProgressView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: uiImage != nil)
        .animation(.easeInOut(duration: 0.2), value: isLoading)
        .task(id: url) {
            await loadIfNeeded()
        }
    }

    private func loadIfNeeded() async {
        guard let url = URL(string: url) else {
            await MainActor.run {
                uiImage = nil
                loadedURLString = nil
                isLoading = false
            }
            onStateChange?(.failure)
            return
        }

        let urlString = url.absoluteString

        if await MainActor.run(body: { loadedURLString == urlString && uiImage != nil }) {
            return
        }

        let alreadyLoading = await MainActor.run { isLoading }
        guard !alreadyLoading else { return }

        await MainActor.run { isLoading = true }
        onStateChange?(.loading)
        defer {
            Task { @MainActor in isLoading = false }
        }

        var request = URLRequest(url: url)
        request.timeoutInterval = 20
        request.cachePolicy = .returnCacheDataElseLoad

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let http = response as? HTTPURLResponse,
                  200..<300 ~= http.statusCode,
                  let image = UIImage(data: data) else {
                onStateChange?(.failure)
                return
            }

            let stillSameURL = await MainActor.run { self.url == urlString }
            guard stillSameURL else { return }

            await MainActor.run {
                uiImage = image
                loadedURLString = urlString
            }
            onStateChange?(.success)
        } catch {
            onStateChange?(.failure)
        }
    }
}

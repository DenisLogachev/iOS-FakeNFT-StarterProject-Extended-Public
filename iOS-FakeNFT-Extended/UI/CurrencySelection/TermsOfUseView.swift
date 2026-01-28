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

// MARK: - WebView
private struct WebView: UIViewRepresentable {
    let url: URL
    @Binding var isLoading: Bool
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(isLoading: $isLoading)
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
    }
    
    // MARK: - Coordinator
    class Coordinator: NSObject, WKNavigationDelegate {
        @Binding var isLoading: Bool
        
        init(isLoading: Binding<Bool>) {
            _isLoading = isLoading
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            isLoading = true
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            isLoading = false
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            isLoading = false
        }
    }
}

// MARK: - Preview
#Preview {
    TermsOfUseView(isPresented: .constant(true))
}

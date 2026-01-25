//
//  CurrencySelectionView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Denis on 25/01/2026.
//

import SwiftUI

struct CurrencySelectionView: View {
    @Bindable var viewModel: CurrencySelectionViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showTermsOfUse = false
    let onPayTap: () -> Void
    
    // MARK: - Computed Properties
    private static let columns = [
        GridItem(.flexible(), spacing: 7),
        GridItem(.flexible(), spacing: 7)
    ]
    
    private var paymentErrorBinding: Binding<Bool> {
        Binding(
            get: { viewModel.paymentError != nil },
            set: { if !$0 { viewModel.dismissPaymentError() } }
        )
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: Self.columns, spacing: 7) {
                    ForEach(viewModel.currencies, id: \.id) { currency in
                        CurrencyRowView(
                            currency: currency,
                            isSelected: viewModel.selectedCurrency?.id == currency.id
                        )
                        .onTapGesture {
                            viewModel.selectCurrency(currency)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 20)
            }
            .navigationTitle(String(localized: "CurrencySelection.title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image.icBackward
                            .renderingMode(.original)
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                CurrencySelectionFooterView(
                    onTermsOfUseTap: {
                        showTermsOfUse = true
                    },
                    onPayTap: {
                        viewModel.showPaymentError(String(localized: "Payment.error.title"))
                    }
                )
            }
            .sheet(isPresented: $showTermsOfUse) {
                TermsOfUseView(isPresented: $showTermsOfUse)
            }
            .alert(
                String(localized: "Payment.error.title"),
                isPresented: paymentErrorBinding
            ) {
                Button(String(localized: "Payment.error.cancel"), role: .cancel) {
                    viewModel.dismissPaymentError()
                }
                Button(String(localized: "Payment.error.retry")) {
                    viewModel.retryPayment()
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    let viewModel = CurrencySelectionViewModel()
    return CurrencySelectionView(viewModel: viewModel, onPayTap: {})
}

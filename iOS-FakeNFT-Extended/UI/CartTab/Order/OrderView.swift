//
//  OrderView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Denis on 25/01/2026.
//

import SwiftUI

struct OrderView: View {
    @Environment(ServicesAssembly.self) var servicesAssembly
    @AppStorage(NFTSortOrder.myOrderStorageKey) private var sortOption: NFTSortOrder = .byInput
    @Bindable var viewModel: OrderViewModel
    @State private var itemToDelete: NFTItem?
    @State private var showCurrencySelection = false
    @State private var showSortingMenu = false
    @State private var showPaymentSuccess = false
    
    private var loadErrorBinding: Binding<Bool> {
        Binding(
            get: { viewModel.loadError != nil },
            set: { if !$0 { viewModel.dismissLoadError() } }
        )
    }
    
    var body: some View {
        NavigationStack {
            contentView
                .toolbar {
                    if !viewModel.isEmpty {
                        sortingToolbarItem
                    }
                }
                .toolbar(itemToDelete == nil ? .visible : .hidden, for: .navigationBar)
                .confirmationDialog(
                    String(localized: "Order.sorting.title"),
                    isPresented: $showSortingMenu,
                    titleVisibility: .visible,
                    actions: sortingActions
                )
                .overlay { deleteConfirmationOverlay }
                .sheet(isPresented: $showCurrencySelection) {
                    CurrencySelectionView(viewModel: .init(serviceAss: servicesAssembly)) { currencyId in
                        Task { await handlePayment(currencyId: currencyId) }
                    }
                }
                .fullScreenCover(isPresented: $showPaymentSuccess) {
                    PaymentSuccessView(onBackToCart: {
                        viewModel.clearCart()
                        showPaymentSuccess = false
                    })
                }
                .task {
                    await viewModel.loadOrder()
                }
                .alert(String(localized: "Error.network"), isPresented: loadErrorBinding) {
                    Button(String(localized: "Error.repeat")) {
                        Task { await viewModel.loadOrder() }
                    }
                    Button(String(localized: "Payment.error.cancel"), role: .cancel) {
                        viewModel.dismissLoadError()
                    }
                } message: {
                    Text(viewModel.loadError ?? "")
                }
        }
    }
}

// MARK: - Private Methods
private extension OrderView {
    func handlePayment(currencyId: String) async {
        do {
            try await viewModel.performPayment(currencyId: currencyId)
            showPaymentSuccess = true
            DispatchQueue.main.async { showCurrencySelection = false }
        } catch {
            viewModel.loadError = (error as NSError).localizedDescription
        }
    }
}

// MARK: - Subviews
private extension OrderView {
    @ViewBuilder
    var contentView: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView()
            } else if viewModel.isEmpty {
                EmptyCartView()
            } else {
                orderListView
            }
        }
    }
    
    var orderListView: some View {
        List {
            ForEach(viewModel.orderItems.sorted(by: sortOption), id: \.id) { item in
                OrderRowView(
                    item: item,
                    onDeleteTap: { itemToDelete = item }
                )
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
                .buttonStyle(.plain)
            }
        }
        .listStyle(.plain)
        .contentMargins(.top, 20, for: .scrollContent)
        .safeAreaInset(edge: .bottom) {
            OrderFooterView(
                nftCount: viewModel.orderItems.count,
                totalPrice: viewModel.totalPrice,
                onPaymentTap: { showCurrencySelection = true }
            )
        }
    }
    
    var sortingToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: { showSortingMenu = true }) {
                Image.icSort
                    .renderingMode(.original)
            }
        }
    }
    
    @ViewBuilder
    func sortingActions() -> some View {
        Button(String(localized: "Order.sorting.byPrice")) { sortOption = .byPrice }
        Button(String(localized: "Order.sorting.byRating")) { sortOption = .byRating }
        Button(String(localized: "Order.sorting.byName")) { sortOption = .byName }
        Button(String(localized: "Order.sorting.cancel"), role: .cancel) {}
    }
    
    @ViewBuilder
    var deleteConfirmationOverlay: some View {
        if let item = itemToDelete {
            DeleteConfirmationView(
                item: item,
                isPresented: Binding(
                    get: { itemToDelete != nil },
                    set: { if !$0 { itemToDelete = nil } }
                ),
                onDelete: {
                    viewModel.deleteItem(byId: item.id)
                    itemToDelete = nil
                }
            )
        }
    }
}

// MARK: - Preview
#Preview {
    TabBarView()
}

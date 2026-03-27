import SwiftUI

struct POSView: View {
    @ObservedObject var viewModel: POSViewModel

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.groupedMenu, id: \.category.id) { group in
                    if !group.items.isEmpty {
                        Section(group.category.rawValue) {
                            ForEach(group.items) { item in
                                MenuItemRowView(item: item) {
                                    viewModel.selectMenuItem(item)
                                }
                            }
                        }
                    }
                }

                Section {
                    if viewModel.cartItems.isEmpty {
                        ContentUnavailableView(
                            "Cart is empty",
                            systemImage: "cart.badge.questionmark",
                            description: Text("Add a menu item to start an order.")
                        )
                    } else {
                        ForEach(viewModel.cartItems) { item in
                            CartItemRowView(
                                item: item,
                                onDecrease: { viewModel.decreaseQuantity(for: item) },
                                onIncrease: { viewModel.increaseQuantity(for: item) }
                            )
                        }

                        LabeledContent(
                            "Total",
                            value: CurrencyFormatter.string(for: viewModel.totalPrice)
                        )
                        .font(.headline)
                    }
                } header: {
                    HStack {
                        Text("Current Cart")
                        Spacer()
                        Text("\(viewModel.cartItemCount) item(s)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Point of Sale")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Clear", role: .destructive, action: viewModel.clearCart)
                        .disabled(viewModel.cartItems.isEmpty)
                }
            }
            .sheet(item: $viewModel.activeMenuItem) { item in
                CustomizationSheetView(item: item) { customization, quantity in
                    viewModel.addToCart(menuItem: item, customization: customization, quantity: quantity)
                }
                .presentationDetents([.medium, .large])
            }
        }
    }
}

#Preview {
    POSView(viewModel: POSViewModel())
}

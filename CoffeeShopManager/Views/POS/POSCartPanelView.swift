import SwiftUI

struct POSCartPanelView: View {
    let items: [POSCartItem]
    let totalPrice: Decimal
    let totalQuantity: Int
    let onIncrease: (POSCartItem) -> Void
    let onDecrease: (POSCartItem) -> Void
    let onCheckout: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Cart")
                    .font(.title2.bold())
                Text("\(totalQuantity) item(s)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)

            Divider()

            if items.isEmpty {
                ContentUnavailableView(
                    "No items",
                    systemImage: "cart",
                    description: Text("Tap a drink to add it to cart.")
                )
                .frame(maxHeight: .infinity)
                .padding(.horizontal, 12)
            } else {
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(items) { item in
                            POSCartRowView(
                                item: item,
                                onIncrease: onIncrease,
                                onDecrease: onDecrease
                            )
                        }
                    }
                    .padding(12)
                }
            }

            Divider()

            VStack(spacing: 12) {
                HStack {
                    Text("Total")
                        .font(.title3.weight(.semibold))
                    Spacer()
                    Text(CurrencyFormatter.string(for: totalPrice))
                        .font(.title2.bold())
                }

                Button("Checkout", action: onCheckout)
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .frame(maxWidth: .infinity)
                    .disabled(items.isEmpty)
            }
            .padding(16)
            .background(Color(.secondarySystemGroupedBackground))
        }
        .background(Color(.systemBackground))
    }
}

#Preview {
    POSCartPanelView(
        items: [
            POSCartItem(drink: POSDrinkItem(name: "Espresso", category: "Coffee", price: 2.5), quantity: 2),
            POSCartItem(drink: POSDrinkItem(name: "Latte", category: "Coffee", price: 4.2), quantity: 1)
        ],
        totalPrice: 9.2,
        totalQuantity: 3,
        onIncrease: { _ in },
        onDecrease: { _ in },
        onCheckout: {}
    )
}

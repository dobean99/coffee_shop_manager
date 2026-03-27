import SwiftUI

struct CartItemRowView: View {
    let item: CartItem
    let onDecrease: () -> Void
    let onIncrease: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(item.menuItem.name)
                    .font(.headline)
                Spacer()
                Text(CurrencyFormatter.string(for: item.lineTotal))
                    .font(.headline)
            }

            Text("\(item.customization.size.rawValue) • \(item.customization.sugar.rawValue) • \(item.customization.ice.rawValue)")
                .font(.footnote)
                .foregroundStyle(.secondary)

            HStack {
                Text("Unit: \(CurrencyFormatter.string(for: item.unitPrice))")
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                Spacer()

                HStack(spacing: 12) {
                    Button("Decrease", systemImage: "minus.circle", action: onDecrease)
                        .labelStyle(.iconOnly)
                        .accessibilityLabel("Decrease quantity")

                    Text("\(item.quantity)")
                        .font(.subheadline.monospacedDigit())
                        .frame(minWidth: 24)

                    Button("Increase", systemImage: "plus.circle", action: onIncrease)
                        .labelStyle(.iconOnly)
                        .accessibilityLabel("Increase quantity")
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    CartItemRowView(
        item: CartItem(
            menuItem: MenuItem(name: "Latte", category: .coffee, basePrice: 4.2, description: "Smooth milk-forward coffee."),
            customization: OrderCustomization(),
            quantity: 2
        ),
        onDecrease: {},
        onIncrease: {}
    )
    .padding()
}

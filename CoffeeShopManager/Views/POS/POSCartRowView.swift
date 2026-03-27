import SwiftUI

struct POSCartRowView: View {
    let item: POSCartItem
    let onIncrease: (POSCartItem) -> Void
    let onDecrease: (POSCartItem) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(item.drink.name)
                    .font(.headline)
                    .lineLimit(1)
                Spacer()
                Text(CurrencyFormatter.string(for: item.lineTotal))
                    .font(.headline)
            }

            HStack {
                Text(CurrencyFormatter.string(for: item.drink.price))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Spacer()

                HStack(spacing: 10) {
                    Button("Decrease", systemImage: "minus.circle.fill") {
                        onDecrease(item)
                    }
                    .labelStyle(.iconOnly)
                    .font(.title3)
                    .foregroundStyle(.red)

                    Text("\(item.quantity)")
                        .font(.headline.monospacedDigit())
                        .frame(minWidth: 28)

                    Button("Increase", systemImage: "plus.circle.fill") {
                        onIncrease(item)
                    }
                    .labelStyle(.iconOnly)
                    .font(.title3)
                    .foregroundStyle(.green)
                }
            }
        }
        .padding(12)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

#Preview {
    POSCartRowView(
        item: POSCartItem(drink: POSDrinkItem(name: "Latte", category: "Coffee", price: 4.2), quantity: 2),
        onIncrease: { _ in },
        onDecrease: { _ in }
    )
    .padding()
}

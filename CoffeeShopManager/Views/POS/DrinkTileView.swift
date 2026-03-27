import SwiftUI

struct DrinkTileView: View {
    let drink: POSDrinkItem
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                Text(drink.name)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                Text(drink.category)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer(minLength: 0)
                Text(CurrencyFormatter.string(for: drink.price))
                    .font(.headline)
                    .foregroundStyle(.blue)
            }
            .frame(maxWidth: .infinity, minHeight: 110, alignment: .leading)
            .padding(14)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Add \(drink.name) to cart")
    }
}

#Preview {
    DrinkTileView(
        drink: POSDrinkItem(name: "Latte", category: "Coffee", price: 4.2),
        onTap: {}
    )
    .padding()
}

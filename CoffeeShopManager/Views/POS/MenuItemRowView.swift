import SwiftUI

struct MenuItemRowView: View {
    let item: MenuItem
    let onAdd: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)
                Text(item.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(CurrencyFormatter.string(for: item.basePrice))
                    .font(.subheadline.weight(.semibold))
            }

            Spacer()

            Button("Customize", systemImage: "plus.circle.fill", action: onAdd)
                .buttonStyle(.borderedProminent)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    MenuItemRowView(
        item: MenuItem(name: "Latte", category: .coffee, basePrice: 4.2, description: "Smooth milk-forward coffee."),
        onAdd: {}
    )
    .padding()
}

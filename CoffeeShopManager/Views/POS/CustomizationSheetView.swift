import SwiftUI

struct CustomizationSheetView: View {
    let item: MenuItem
    let onAdd: (OrderCustomization, Int) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var customization = OrderCustomization()
    @State private var quantity = 1

    private var unitPrice: Decimal {
        item.basePrice * customization.size.priceMultiplier
    }

    private var totalPrice: Decimal {
        unitPrice * Decimal(quantity)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Item") {
                    Text(item.name)
                        .font(.headline)
                    Text(item.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("Base: \(CurrencyFormatter.string(for: item.basePrice))")
                        .font(.subheadline.weight(.semibold))
                }

                Section("Customize") {
                    Picker("Size", selection: $customization.size) {
                        ForEach(DrinkSize.allCases) { size in
                            Text(size.rawValue).tag(size)
                        }
                    }

                    Picker("Sugar", selection: $customization.sugar) {
                        ForEach(SugarLevel.allCases) { sugar in
                            Text(sugar.rawValue).tag(sugar)
                        }
                    }

                    Picker("Ice", selection: $customization.ice) {
                        ForEach(IceLevel.allCases) { ice in
                            Text(ice.rawValue).tag(ice)
                        }
                    }
                }

                Section("Quantity") {
                    Stepper(value: $quantity, in: 1...20) {
                        Text("\(quantity) cup(s)")
                    }
                }

                Section("Summary") {
                    LabeledContent("Unit price", value: CurrencyFormatter.string(for: unitPrice))
                    LabeledContent("Total", value: CurrencyFormatter.string(for: totalPrice))
                }
            }
            .navigationTitle("Customize")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add to Cart") {
                        onAdd(customization, quantity)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

#Preview {
    CustomizationSheetView(
        item: MenuItem(name: "Latte", category: .coffee, basePrice: 4.2, description: "Smooth milk-forward coffee."),
        onAdd: { _, _ in }
    )
}

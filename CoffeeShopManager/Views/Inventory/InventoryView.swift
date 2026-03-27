import SwiftUI

struct InventoryView: View {
    @ObservedObject var viewModel: InventoryViewModel

    var body: some View {
        NavigationStack {
            List {
                if !viewModel.lowStockItems.isEmpty {
                    Section {
                        ForEach(viewModel.lowStockItems) { item in
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundStyle(.orange)
                                Text("\(item.name) is low (\(item.quantity) \(item.unit))")
                                    .font(.subheadline)
                            }
                        }
                    } header: {
                        Text("Low Stock Warning")
                    }
                }

                Section {
                    ForEach(viewModel.items) { item in
                        InventoryRowView(item: item) {
                            viewModel.restock(item: item, amount: 100)
                        }
                    }
                } header: {
                    Text("Inventory Items")
                }
            }
            .navigationTitle("Inventory")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Simulate Order") {
                        viewModel.simulateOrderCreation()
                    }
                }
            }
            .overlay(alignment: .bottom) {
                if let summary = viewModel.lastProcessedOrderSummary {
                    Text(summary)
                        .font(.footnote)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(.thinMaterial, in: Capsule())
                        .padding(.bottom, 8)
                }
            }
        }
    }
}

private struct InventoryRowView: View {
    let item: InventoryItem
    let onRestock: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(item.name)
                        .font(.headline)
                    if item.isLowStock {
                        Text("LOW")
                            .font(.caption2.weight(.bold))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.orange.opacity(0.2), in: Capsule())
                    }
                }
                Text("\(item.quantity) \(item.unit)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button("+100", action: onRestock)
                .buttonStyle(.bordered)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    InventoryView(viewModel: InventoryViewModel())
}

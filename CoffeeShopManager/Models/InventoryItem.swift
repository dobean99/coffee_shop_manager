import Foundation

struct InventoryItem: Identifiable, Hashable {
    let id: UUID
    let name: String
    let unit: String
    var quantity: Int
    let lowStockThreshold: Int

    init(
        id: UUID = UUID(),
        name: String,
        unit: String,
        quantity: Int,
        lowStockThreshold: Int
    ) {
        self.id = id
        self.name = name
        self.unit = unit
        self.quantity = quantity
        self.lowStockThreshold = lowStockThreshold
    }

    var isLowStock: Bool {
        quantity <= lowStockThreshold
    }
}

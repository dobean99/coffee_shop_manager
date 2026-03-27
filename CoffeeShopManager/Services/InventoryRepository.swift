import Foundation

protocol InventoryRepository {
    func fetchItems() -> [InventoryItem]
    func saveItems(_ items: [InventoryItem])
}

final class InMemoryInventoryRepository: InventoryRepository {
    private var storage: [InventoryItem]

    init(seed: [InventoryItem] = InMemoryInventoryRepository.defaultSeed) {
        self.storage = seed
    }

    func fetchItems() -> [InventoryItem] {
        storage
    }

    func saveItems(_ items: [InventoryItem]) {
        storage = items
    }

    private static let defaultSeed: [InventoryItem] = [
        InventoryItem(name: "Milk", unit: "ml", quantity: 3000, lowStockThreshold: 700),
        InventoryItem(name: "Coffee Beans", unit: "g", quantity: 2500, lowStockThreshold: 500),
        InventoryItem(name: "Tea Leaves", unit: "g", quantity: 1000, lowStockThreshold: 200),
        InventoryItem(name: "Cups", unit: "pcs", quantity: 240, lowStockThreshold: 60)
    ]
}

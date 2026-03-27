import Combine
import Foundation

final class InventoryViewModel: ObservableObject {
    @Published private(set) var items: [InventoryItem] = []
    @Published private(set) var lastProcessedOrderSummary: String?

    private let repository: InventoryRepository
    private let consumptionCalculator: OrderConsumptionCalculator
    private var cancellables = Set<AnyCancellable>()

    init(
        repository: InventoryRepository = InMemoryInventoryRepository(),
        consumptionCalculator: OrderConsumptionCalculator = OrderConsumptionCalculator()
    ) {
        self.repository = repository
        self.consumptionCalculator = consumptionCalculator
        self.items = repository.fetchItems()
        observeOrders()
    }

    var lowStockItems: [InventoryItem] {
        items.filter(\.isLowStock)
    }

    func process(order: InventoryOrder) {
        let required = consumptionCalculator.requiredInventory(for: order)
        guard !required.isEmpty else { return }

        var updated = items

        for index in updated.indices {
            let name = updated[index].name
            if let deduction = required[name] {
                updated[index].quantity = max(0, updated[index].quantity - deduction)
            }
        }

        items = updated
        repository.saveItems(updated)

        let orderCount = order.lines.reduce(0) { $0 + $1.quantity }
        lastProcessedOrderSummary = "Processed order with \(orderCount) drink(s)."
    }

    func restock(item: InventoryItem, amount: Int) {
        guard amount > 0, let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[index].quantity += amount
        repository.saveItems(items)
    }

    func simulateOrderCreation() {
        let simulated = InventoryOrder(lines: [
            InventoryOrderLine(drinkName: "Latte", quantity: 2),
            InventoryOrderLine(drinkName: "Americano", quantity: 1)
        ])
        NotificationCenter.default.post(name: .posOrderCreated, object: simulated)
    }

    private func observeOrders() {
        NotificationCenter.default.publisher(for: .posOrderCreated)
            .compactMap { $0.object as? InventoryOrder }
            .sink { [weak self] order in
                self?.process(order: order)
            }
            .store(in: &cancellables)
    }
}

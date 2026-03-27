import Foundation

struct POSDrinkItem: Identifiable, Hashable {
    let id: UUID
    let name: String
    let category: String
    let price: Decimal

    init(id: UUID = UUID(), name: String, category: String, price: Decimal) {
        self.id = id
        self.name = name
        self.category = category
        self.price = price
    }
}

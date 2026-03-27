import Foundation

struct POSCartItem: Identifiable, Hashable {
    let id: UUID
    let drink: POSDrinkItem
    var quantity: Int

    init(id: UUID = UUID(), drink: POSDrinkItem, quantity: Int = 1) {
        self.id = id
        self.drink = drink
        self.quantity = quantity
    }

    var lineTotal: Decimal {
        drink.price * Decimal(quantity)
    }
}

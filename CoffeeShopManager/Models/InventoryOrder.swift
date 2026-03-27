import Foundation

struct InventoryOrder {
    let lines: [InventoryOrderLine]
}

struct InventoryOrderLine {
    let drinkName: String
    let quantity: Int
}

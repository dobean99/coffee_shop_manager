import Foundation

struct OrderConsumptionCalculator {
    private let recipes: [String: [String: Int]] = [
        "Espresso": ["Coffee Beans": 18, "Cups": 1],
        "Americano": ["Coffee Beans": 18, "Cups": 1],
        "Cappuccino": ["Coffee Beans": 18, "Milk": 150, "Cups": 1],
        "Latte": ["Coffee Beans": 18, "Milk": 200, "Cups": 1],
        "Mocha": ["Coffee Beans": 18, "Milk": 180, "Cups": 1],
        "Matcha Latte": ["Milk": 180, "Cups": 1],
        "Black Tea": ["Tea Leaves": 10, "Cups": 1],
        "Peach Iced Tea": ["Tea Leaves": 10, "Cups": 1],
        "Cold Brew": ["Coffee Beans": 22, "Cups": 1]
    ]

    func requiredInventory(for order: InventoryOrder) -> [String: Int] {
        var totals: [String: Int] = [:]

        for line in order.lines {
            guard let recipe = recipes[line.drinkName] else { continue }

            for (itemName, amountPerDrink) in recipe {
                totals[itemName, default: 0] += amountPerDrink * line.quantity
            }
        }

        return totals
    }
}

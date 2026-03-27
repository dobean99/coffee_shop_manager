import Foundation

protocol MenuRepository {
    func loadMenu() -> [MenuItem]
}

struct LocalMenuRepository: MenuRepository {
    func loadMenu() -> [MenuItem] {
        [
            MenuItem(name: "Espresso", category: .coffee, basePrice: 2.50, description: "Rich and concentrated shot."),
            MenuItem(name: "Cappuccino", category: .coffee, basePrice: 3.80, description: "Espresso, steamed milk, foam."),
            MenuItem(name: "Latte", category: .coffee, basePrice: 4.20, description: "Smooth milk-forward coffee."),
            MenuItem(name: "Matcha Latte", category: .tea, basePrice: 4.50, description: "Premium matcha with milk."),
            MenuItem(name: "Peach Iced Tea", category: .tea, basePrice: 3.60, description: "Refreshing peach-flavored tea."),
            MenuItem(name: "Butter Croissant", category: .pastry, basePrice: 2.90, description: "Flaky, all-butter pastry.")
        ]
    }
}

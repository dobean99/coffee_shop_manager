import Foundation

final class MenuManagementViewModel: ObservableObject {
    enum CategoryFilter: String, CaseIterable, Identifiable {
        case all = "All"
        case coffee = "Coffee"
        case tea = "Tea"
        case juice = "Juice"

        var id: String { rawValue }

        var category: MenuCategory? {
            switch self {
            case .all: return nil
            case .coffee: return .coffee
            case .tea: return .tea
            case .juice: return .juice
            }
        }
    }

    @Published private(set) var menuItems: [MenuItem]
    @Published var searchText: String = ""
    @Published var selectedFilter: CategoryFilter = .all

    init(menuItems: [MenuItem] = MenuManagementViewModel.mockItems) {
        self.menuItems = menuItems
    }

    var filteredItems: [MenuItem] {
        menuItems.filter { item in
            let matchesSearch = searchText.isEmpty || item.name.localizedCaseInsensitiveContains(searchText)
            let matchesCategory = selectedFilter.category == nil || item.category == selectedFilter.category
            return matchesSearch && matchesCategory
        }
        .sorted { $0.name < $1.name }
    }

    func addItem(_ item: MenuItem) {
        menuItems.append(item)
    }

    func updateItem(_ item: MenuItem) {
        guard let index = menuItems.firstIndex(where: { $0.id == item.id }) else { return }
        menuItems[index] = item
    }

    func deleteItem(_ item: MenuItem) {
        menuItems.removeAll { $0.id == item.id }
    }

    func deleteItems(_ items: [MenuItem]) {
        let ids = Set(items.map(\.id))
        menuItems.removeAll { ids.contains($0.id) }
    }

    func item(with id: UUID) -> MenuItem? {
        menuItems.first { $0.id == id }
    }

    private static let mockItems: [MenuItem] = [
        MenuItem(name: "Latte", category: .coffee, price: 4.20, imageName: "cup.and.saucer.fill"),
        MenuItem(name: "Cappuccino", category: .coffee, price: 3.80, imageName: "cup.and.saucer.fill"),
        MenuItem(name: "Americano", category: .coffee, price: 3.00, imageName: "cup.and.saucer.fill"),
        MenuItem(name: "Matcha Tea", category: .tea, price: 4.40, imageName: "leaf.fill"),
        MenuItem(name: "Black Tea", category: .tea, price: 2.90, imageName: "leaf.fill"),
        MenuItem(name: "Orange Juice", category: .juice, price: 3.50, imageName: "drop.fill")
    ]
}

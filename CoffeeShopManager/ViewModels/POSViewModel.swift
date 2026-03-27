import Foundation

final class POSViewModel: ObservableObject {
    @Published private(set) var menuItems: [MenuItem] = []
    @Published private(set) var cartItems: [CartItem] = []
    @Published var activeMenuItem: MenuItem?

    private let menuRepository: MenuRepository

    init(menuRepository: MenuRepository = LocalMenuRepository()) {
        self.menuRepository = menuRepository
        self.menuItems = menuRepository.loadMenu()
    }

    var groupedMenu: [(category: MenuCategory, items: [MenuItem])] {
        MenuCategory.allCases.map { category in
            let items = menuItems.filter { $0.category == category }
            return (category, items)
        }
    }

    var totalPrice: Decimal {
        cartItems.reduce(0) { partial, item in
            partial + item.lineTotal
        }
    }

    var cartItemCount: Int {
        cartItems.reduce(0) { partial, item in
            partial + item.quantity
        }
    }

    func selectMenuItem(_ item: MenuItem) {
        activeMenuItem = item
    }

    func addToCart(menuItem: MenuItem, customization: OrderCustomization, quantity: Int) {
        guard quantity > 0 else { return }

        if let existingIndex = cartItems.firstIndex(where: {
            $0.menuItem.id == menuItem.id && $0.customization == customization
        }) {
            cartItems[existingIndex].quantity += quantity
        } else {
            let newItem = CartItem(menuItem: menuItem, customization: customization, quantity: quantity)
            cartItems.append(newItem)
        }

        activeMenuItem = nil
    }

    func increaseQuantity(for item: CartItem) {
        guard let index = cartItems.firstIndex(where: { $0.id == item.id }) else { return }
        cartItems[index].quantity += 1
    }

    func decreaseQuantity(for item: CartItem) {
        guard let index = cartItems.firstIndex(where: { $0.id == item.id }) else { return }

        if cartItems[index].quantity <= 1 {
            cartItems.remove(at: index)
        } else {
            cartItems[index].quantity -= 1
        }
    }

    func clearCart() {
        cartItems.removeAll()
    }
}

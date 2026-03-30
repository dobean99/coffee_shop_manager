import Combine
import Foundation

final class CoffeePOSViewModel: ObservableObject {
    @Published private(set) var drinks: [POSDrinkItem]
    @Published private(set) var cartItems: [POSCartItem] = []
    @Published private(set) var completedOrders: [POSCompletedOrder] = []
    @Published var activePayment: QRPaymentInfo?
    private var cancellables = Set<AnyCancellable>()

    init(drinks: [POSDrinkItem] = CoffeePOSViewModel.mockDrinks) {
        self.drinks = drinks
    }

    init(menuManagementViewModel: MenuManagementViewModel) {
        self.drinks = Self.mapToDrinks(menuManagementViewModel.menuItems)
        bindMenu(menuManagementViewModel)
    }

    var totalPrice: Decimal {
        cartItems.reduce(0) { $0 + $1.lineTotal }
    }

    var totalQuantity: Int {
        cartItems.reduce(0) { $0 + $1.quantity }
    }

    func addToCart(_ drink: POSDrinkItem) {
        if let index = cartItems.firstIndex(where: { $0.drink.id == drink.id }) {
            cartItems[index].quantity += 1
        } else {
            cartItems.append(POSCartItem(drink: drink, quantity: 1))
        }
    }

    func increaseQuantity(for item: POSCartItem) {
        guard let index = cartItems.firstIndex(where: { $0.id == item.id }) else { return }
        cartItems[index].quantity += 1
    }

    func decreaseQuantity(for item: POSCartItem) {
        guard let index = cartItems.firstIndex(where: { $0.id == item.id }) else { return }
        if cartItems[index].quantity == 1 {
            cartItems.remove(at: index)
        } else {
            cartItems[index].quantity -= 1
        }
    }

    func checkout() {
        guard !cartItems.isEmpty else { return }

        let checkoutTotal = totalPrice
        let completedOrder = POSCompletedOrder(
            lines: cartItems.map { item in
                POSCompletedOrderLine(
                    drinkName: item.drink.name,
                    quantity: item.quantity,
                    lineTotal: item.lineTotal
                )
            }
        )
        completedOrders.append(completedOrder)

        let order = InventoryOrder(
            lines: cartItems.map { item in
                InventoryOrderLine(drinkName: item.drink.name, quantity: item.quantity)
            }
        )
        NotificationCenter.default.post(name: .posOrderCreated, object: order)

        let shortOrderID = String(completedOrder.id.uuidString.prefix(8)).uppercased()
        let transferContent = "ORDER-\(shortOrderID)"
        activePayment = QRPaymentInfo(
            id: transferContent,
            amount: checkoutTotal,
            bankName: "Vietcombank",
            bankBin: "970436",
            accountNumber: "0271001066908",
            transferContent: transferContent
        )
        cartItems.removeAll()
    }

    func clearActivePayment() {
        activePayment = nil
    }

    private static let mockDrinks: [POSDrinkItem] = [
        POSDrinkItem(name: "Espresso", category: "Coffee", price: 2.50),
        POSDrinkItem(name: "Americano", category: "Coffee", price: 3.00),
        POSDrinkItem(name: "Cappuccino", category: "Coffee", price: 3.80),
        POSDrinkItem(name: "Latte", category: "Coffee", price: 4.20),
        POSDrinkItem(name: "Mocha", category: "Coffee", price: 4.60),
        POSDrinkItem(name: "Matcha Latte", category: "Tea", price: 4.40),
        POSDrinkItem(name: "Black Tea", category: "Tea", price: 2.90),
        POSDrinkItem(name: "Peach Iced Tea", category: "Tea", price: 3.60),
        POSDrinkItem(name: "Cold Brew", category: "Coffee", price: 4.00)
    ]

    private func bindMenu(_ menuManagementViewModel: MenuManagementViewModel) {
        menuManagementViewModel.$menuItems
            .map(Self.mapToDrinks(_:))
            .sink { [weak self] updatedDrinks in
                guard let self else { return }
                drinks = updatedDrinks
                let validIDs = Set(updatedDrinks.map(\.id))
                cartItems.removeAll { !validIDs.contains($0.drink.id) }
            }
            .store(in: &cancellables)
    }

    private static func mapToDrinks(_ items: [MenuItem]) -> [POSDrinkItem] {
        items
            .map { item in
                POSDrinkItem(
                    id: item.id,
                    name: item.name,
                    category: item.category.rawValue,
                    price: item.price
                )
            }
            .sorted { $0.name < $1.name }
    }
}

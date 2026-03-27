import Foundation

struct CartItem: Identifiable, Hashable {
    let id: UUID
    let menuItem: MenuItem
    var customization: OrderCustomization
    var quantity: Int

    init(
        id: UUID = UUID(),
        menuItem: MenuItem,
        customization: OrderCustomization,
        quantity: Int = 1
    ) {
        self.id = id
        self.menuItem = menuItem
        self.customization = customization
        self.quantity = quantity
    }

    var unitPrice: Decimal {
        menuItem.basePrice * customization.size.priceMultiplier
    }

    var lineTotal: Decimal {
        unitPrice * Decimal(quantity)
    }
}

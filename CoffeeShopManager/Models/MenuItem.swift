import Foundation

struct MenuItem: Identifiable, Hashable {
    let id: UUID
    let name: String
    let category: MenuCategory
    let basePrice: Decimal
    let description: String
    let imageName: String?

    init(
        id: UUID = UUID(),
        name: String,
        category: MenuCategory,
        basePrice: Decimal,
        description: String,
        imageName: String? = nil
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.basePrice = basePrice
        self.description = description
        self.imageName = imageName
    }

    init(
        id: UUID = UUID(),
        name: String,
        category: MenuCategory,
        price: Decimal,
        imageName: String? = nil
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.basePrice = price
        self.description = ""
        self.imageName = imageName
    }

    var price: Decimal {
        basePrice
    }
}

enum MenuCategory: String, CaseIterable, Identifiable {
    case coffee = "Coffee"
    case tea = "Tea"
    case juice = "Juice"
    case pastry = "Pastry"

    var id: String { rawValue }
}

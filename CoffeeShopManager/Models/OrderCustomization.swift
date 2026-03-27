import Foundation

enum DrinkSize: String, CaseIterable, Identifiable {
    case small = "Small"
    case medium = "Medium"
    case large = "Large"

    var id: String { rawValue }

    var priceMultiplier: Decimal {
        switch self {
        case .small: return 1.0
        case .medium: return 1.2
        case .large: return 1.4
        }
    }
}

enum SugarLevel: String, CaseIterable, Identifiable {
    case noSugar = "No Sugar"
    case lessSugar = "Less Sugar"
    case regular = "Regular"

    var id: String { rawValue }
}

enum IceLevel: String, CaseIterable, Identifiable {
    case noIce = "No Ice"
    case lessIce = "Less Ice"
    case regularIce = "Regular Ice"

    var id: String { rawValue }
}

struct OrderCustomization: Hashable {
    var size: DrinkSize = .medium
    var sugar: SugarLevel = .regular
    var ice: IceLevel = .regularIce
}

import Foundation

enum CurrencyOption: String, CaseIterable, Identifiable {
    case usd = "USD"
    case vnd = "VND"
    case eur = "EUR"

    var id: String { rawValue }
}

struct AppSettings {
    var shopName: String
    var address: String
    var currency: CurrencyOption
    var taxPercentage: Double
    var isDarkMode: Bool
    var soundEffectsEnabled: Bool
    var notificationsEnabled: Bool
}

import Foundation

enum CurrencyOption: String, CaseIterable, Identifiable {
    case usd = "USD"
    case vnd = "VND"
    case eur = "EUR"

    var id: String { rawValue }
}

enum AppLanguage: String, CaseIterable, Identifiable {
    case english = "en"
    case vietnamese = "vi"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .english:
            return "English"
        case .vietnamese:
            return "Tiếng Việt"
        }
    }

    var localeIdentifier: String {
        switch self {
        case .english:
            return "en"
        case .vietnamese:
            return "vi"
        }
    }
}

struct AppSettings {
    var shopName: String
    var address: String
    var currency: CurrencyOption
    var taxPercentage: Double
    var language: AppLanguage
    var isDarkMode: Bool
    var soundEffectsEnabled: Bool
    var notificationsEnabled: Bool
}

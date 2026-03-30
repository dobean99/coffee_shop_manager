import SwiftUI

final class SettingsViewModel: ObservableObject {
    @AppStorage("settings.shopName") var shopName: String = "Brew Haven Coffee"
    @AppStorage("settings.address") var address: String = "123 Bean Street"
    @AppStorage("settings.currency") private var currencyRawValue: String = CurrencyOption.vnd.rawValue
    @AppStorage("settings.taxPercentage") var taxPercentage: Double = 8.5
    @AppStorage("settings.language") private var languageRawValue: String = AppLanguage.english.rawValue

    @AppStorage("settings.darkMode") var isDarkMode: Bool = false
    @AppStorage("settings.soundEffects") var soundEffectsEnabled: Bool = true
    @AppStorage("settings.notifications") var notificationsEnabled: Bool = true

    @Published var staffMembers: [StaffMember] = [
        StaffMember(name: "Anna", role: "Manager"),
        StaffMember(name: "Liam", role: "Barista")
    ]

    @Published var newStaffName: String = ""
    @Published var newStaffRole: String = ""
    @Published var isShowingResetConfirmation = false
    @Published var exportMessage: String?

    var currency: CurrencyOption {
        get { CurrencyOption(rawValue: currencyRawValue) ?? .vnd }
        set { currencyRawValue = newValue.rawValue }
    }

    var appLanguage: AppLanguage {
        get { AppLanguage(rawValue: languageRawValue) ?? .english }
        set { languageRawValue = newValue.rawValue }
    }

    var currentSettingsSnapshot: AppSettings {
        AppSettings(
            shopName: shopName,
            address: address,
            currency: currency,
            taxPercentage: taxPercentage,
            language: appLanguage,
            isDarkMode: isDarkMode,
            soundEffectsEnabled: soundEffectsEnabled,
            notificationsEnabled: notificationsEnabled
        )
    }

    var canAddStaffMember: Bool {
        !newStaffName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !newStaffRole.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var appVersion: String {
        let shortVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(shortVersion) (\(build))"
    }

    func addStaffMember() {
        guard canAddStaffMember else { return }

        let member = StaffMember(
            name: newStaffName.trimmingCharacters(in: .whitespacesAndNewlines),
            role: newStaffRole.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        staffMembers.append(member)
        newStaffName = ""
        newStaffRole = ""
    }

    func deleteStaffMembers(at offsets: IndexSet) {
        staffMembers.remove(atOffsets: offsets)
    }

    func exportData() {
        let settings = currentSettingsSnapshot
        exportMessage = localizedFormat(
            "settings.export.message",
            staffMembers.count,
            settings.currency.rawValue,
            settings.taxPercentage
        )
    }

    func resetAllData() {
        shopName = "Coffee Shop"
        address = ""
        currency = .vnd
        taxPercentage = 0
        appLanguage = .english
        isDarkMode = false
        soundEffectsEnabled = true
        notificationsEnabled = true

        staffMembers = []
        newStaffName = ""
        newStaffRole = ""
    }

    private var localizationBundle: Bundle {
        guard
            let path = Bundle.main.path(forResource: appLanguage.localeIdentifier, ofType: "lproj"),
            let bundle = Bundle(path: path)
        else {
            return .main
        }
        return bundle
    }

    func localized(_ key: String) -> String {
        localizationBundle.localizedString(forKey: key, value: nil, table: nil)
    }

    func localizedFormat(_ key: String, _ arguments: CVarArg...) -> String {
        let format = localized(key)
        return String(format: format, locale: Locale(identifier: appLanguage.localeIdentifier), arguments: arguments)
    }
}

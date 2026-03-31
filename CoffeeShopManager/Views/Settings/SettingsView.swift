import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()

    private var exportAlertPresented: Binding<Bool> {
        Binding(
            get: { viewModel.exportMessage != nil },
            set: { isPresented in
                if !isPresented {
                    viewModel.exportMessage = nil
                }
            }
        )
    }

    var body: some View {
        NavigationStack {
            Form {
                shopSettingsSection
                appPreferencesSection
                staffSettingsSection
                dataManagementSection
                aboutSection
            }
            .navigationTitle("settings.title")
            .scrollContentBackground(.hidden)
            .background(.themeBackground)
            .alert("settings.reset.title", isPresented: $viewModel.isShowingResetConfirmation) {
                Button("settings.cancel", role: .cancel) { }
                Button("settings.reset.confirm", role: .destructive) {
                    viewModel.resetAllData()
                }
            } message: {
                Text("settings.reset.message")
            }
            .alert("settings.export.complete", isPresented: exportAlertPresented) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.exportMessage ?? "")
            }
        }
        .tint(.themeAccent)
        .environment(\.locale, Locale(identifier: viewModel.appLanguage.localeIdentifier))
    }

    private var shopSettingsSection: some View {
        Section("settings.section.shop") {
            TextField("settings.shop.name", text: $viewModel.shopName)
            TextField("settings.shop.address", text: $viewModel.address, axis: .vertical)
                .lineLimit(2...4)

            Picker("settings.shop.currency", selection: Binding(
                get: { viewModel.currency },
                set: { viewModel.currency = $0 }
            )) {
                ForEach(CurrencyOption.allCases) { option in
                    Text(option.rawValue).tag(option)
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("settings.shop.tax")
                    Spacer()
                    TextField("settings.shop.tax", value: $viewModel.taxPercentage, format: .number.precision(.fractionLength(0...2)))
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 80)
                    Text("%")
                        .foregroundStyle(.secondary)
                }

                Stepper("settings.shop.tax.adjust", value: $viewModel.taxPercentage, in: 0...30, step: 0.5)
                    .labelsHidden()
            }
        }
    }

    private var appPreferencesSection: some View {
        Section("settings.section.preferences") {
            Picker("settings.preferences.language", selection: Binding(
                get: { viewModel.appLanguage },
                set: { viewModel.appLanguage = $0 }
            )) {
                ForEach(AppLanguage.allCases) { language in
                    Text(language.displayName).tag(language)
                }
            }
            Toggle("settings.preferences.darkMode", isOn: $viewModel.isDarkMode)
            Toggle("settings.preferences.soundEffects", isOn: $viewModel.soundEffectsEnabled)
            Toggle("settings.preferences.notifications", isOn: $viewModel.notificationsEnabled)
        }
    }

    private var staffSettingsSection: some View {
        Section("settings.section.staff") {
            TextField("settings.staff.name", text: $viewModel.newStaffName)
            TextField("settings.staff.role", text: $viewModel.newStaffRole)

            Button("settings.staff.add") {
                viewModel.addStaffMember()
            }
            .disabled(!viewModel.canAddStaffMember)

            if viewModel.staffMembers.isEmpty {
                ContentUnavailableView(
                    "settings.staff.empty.title",
                    systemImage: "person.2.slash",
                    description: Text("settings.staff.empty.description")
                )
            } else {
                ForEach(viewModel.staffMembers) { member in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(member.name)
                            Text(member.role)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                    }
                }
                .onDelete(perform: viewModel.deleteStaffMembers)
            }
        }
    }

    private var dataManagementSection: some View {
        Section("settings.section.data") {
            Button("settings.data.export") {
                viewModel.exportData()
            }

            Button("settings.data.reset", role: .destructive) {
                viewModel.isShowingResetConfirmation = true
            }
        }
    }

    private var aboutSection: some View {
        Section("settings.section.about") {
            LabeledContent("settings.about.version", value: viewModel.appVersion)
            LabeledContent("settings.about.developer", value: "Coffee Shop Engineering")
            LabeledContent("settings.about.support", value: "support@coffeeshopmanager.app")
        }
    }
}

#Preview {
    SettingsView()
}

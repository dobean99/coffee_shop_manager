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
            .navigationTitle("Settings")
            .alert("Reset All Data?", isPresented: $viewModel.isShowingResetConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Reset", role: .destructive) {
                    viewModel.resetAllData()
                }
            } message: {
                Text("This action clears settings and staff data. It cannot be undone.")
            }
            .alert("Export Complete", isPresented: exportAlertPresented) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.exportMessage ?? "")
            }
        }
        .preferredColorScheme(viewModel.isDarkMode ? .dark : .light)
    }

    private var shopSettingsSection: some View {
        Section("Shop Settings") {
            TextField("Shop name", text: $viewModel.shopName)
            TextField("Address", text: $viewModel.address, axis: .vertical)
                .lineLimit(2...4)

            Picker("Currency", selection: Binding(
                get: { viewModel.currency },
                set: { viewModel.currency = $0 }
            )) {
                ForEach(CurrencyOption.allCases) { option in
                    Text(option.rawValue).tag(option)
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Tax")
                    Spacer()
                    TextField("Tax", value: $viewModel.taxPercentage, format: .number.precision(.fractionLength(0...2)))
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 80)
                    Text("%")
                        .foregroundStyle(.secondary)
                }

                Stepper("Adjust tax", value: $viewModel.taxPercentage, in: 0...30, step: 0.5)
                    .labelsHidden()
            }
        }
    }

    private var appPreferencesSection: some View {
        Section("App Preferences") {
            Toggle("Dark Mode", isOn: $viewModel.isDarkMode)
            Toggle("Sound Effects", isOn: $viewModel.soundEffectsEnabled)
            Toggle("Notifications", isOn: $viewModel.notificationsEnabled)
        }
    }

    private var staffSettingsSection: some View {
        Section("Staff Settings") {
            TextField("Staff name", text: $viewModel.newStaffName)
            TextField("Role", text: $viewModel.newStaffRole)

            Button("Add Staff Member") {
                viewModel.addStaffMember()
            }
            .disabled(!viewModel.canAddStaffMember)

            if viewModel.staffMembers.isEmpty {
                ContentUnavailableView(
                    "No Staff Members",
                    systemImage: "person.2.slash",
                    description: Text("Add a team member to get started.")
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
        Section("Data Management") {
            Button("Export Data") {
                viewModel.exportData()
            }

            Button("Reset All Data", role: .destructive) {
                viewModel.isShowingResetConfirmation = true
            }
        }
    }

    private var aboutSection: some View {
        Section("About") {
            LabeledContent("App Version", value: viewModel.appVersion)
            LabeledContent("Developer", value: "Coffee Shop Engineering")
            LabeledContent("Support", value: "support@coffeeshopmanager.app")
        }
    }
}

#Preview {
    SettingsView()
}

import SwiftUI

struct MenuDetailView: View {
    enum Mode {
        case add
        case edit(MenuItem)

        var title: String {
            switch self {
            case .add: return "Add Menu Item"
            case .edit: return "Edit Menu Item"
            }
        }
    }

    let mode: Mode
    let onSave: (MenuItem) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var name: String
    @State private var priceText: String
    @State private var category: MenuCategory
    @State private var imageName: String

    init(mode: Mode, onSave: @escaping (MenuItem) -> Void) {
        self.mode = mode
        self.onSave = onSave

        switch mode {
        case .add:
            _name = State(initialValue: "")
            _priceText = State(initialValue: "")
            _category = State(initialValue: .coffee)
            _imageName = State(initialValue: "")
        case let .edit(item):
            _name = State(initialValue: item.name)
            _priceText = State(initialValue: NSDecimalNumber(decimal: item.price).stringValue)
            _category = State(initialValue: item.category)
            _imageName = State(initialValue: item.imageName ?? "")
        }
    }

    private var parsedPrice: Decimal? {
        Decimal(string: priceText)
    }

    private var isSaveDisabled: Bool {
        name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || (parsedPrice ?? 0) <= 0
    }

    var body: some View {
        Form {
            Section("Details") {
                TextField("Name", text: $name)
                    .textInputAutocapitalization(.words)

                TextField("Price", text: $priceText)
                    .keyboardType(.decimalPad)

                Picker("Category", selection: $category) {
                    Text(MenuCategory.coffee.rawValue).tag(MenuCategory.coffee)
                    Text(MenuCategory.tea.rawValue).tag(MenuCategory.tea)
                    Text(MenuCategory.juice.rawValue).tag(MenuCategory.juice)
                }

                TextField("SF Symbol image (optional)", text: $imageName)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }
        }
        .navigationTitle(mode.title)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    save()
                }
                .disabled(isSaveDisabled)
            }
        }
    }

    private func save() {
        guard let price = parsedPrice else { return }

        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedImage = imageName.trimmingCharacters(in: .whitespacesAndNewlines)

        let item: MenuItem

        switch mode {
        case .add:
            item = MenuItem(
                name: trimmedName,
                category: category,
                price: price,
                imageName: trimmedImage.isEmpty ? nil : trimmedImage
            )
        case let .edit(existing):
            item = MenuItem(
                id: existing.id,
                name: trimmedName,
                category: category,
                basePrice: price,
                description: existing.description,
                imageName: trimmedImage.isEmpty ? nil : trimmedImage
            )
        }

        onSave(item)
        dismiss()
    }
}

#Preview {
    NavigationStack {
        MenuDetailView(mode: .add) { _ in }
    }
}

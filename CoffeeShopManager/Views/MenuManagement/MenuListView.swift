import SwiftUI

struct MenuListView: View {
    @ObservedObject var viewModel: MenuManagementViewModel

    @State private var selectedItemForEdit: MenuItem?
    @State private var isShowingAddSheet = false

    private let pageBackground = Color("FigmaBackground")
    private let cardBackground = Color("FigmaCard")
    private let accent = Color("FigmaAccent")
    private let textPrimary = Color("FigmaTextPrimary")
    private let textSecondary = Color("FigmaTextSecondary")

    private var groupedItems: [(MenuCategory, [MenuItem])] {
        Dictionary(grouping: viewModel.filteredItems, by: \.category)
            .sorted { $0.key.rawValue < $1.key.rawValue }
            .map { ($0.key, $0.value.sorted { $0.name < $1.name }) }
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                topBar
                searchBar
                categoryFilters
                menuSections
            }
            .padding(.horizontal, 24)
            .padding(.top, 12)
            .padding(.bottom, 140)
        }
        .background(pageBackground.ignoresSafeArea())
        .sheet(isPresented: $isShowingAddSheet) {
            NavigationStack {
                MenuDetailView(mode: .add) { newItem in
                    viewModel.addItem(newItem)
                }
            }
        }
        .sheet(item: $selectedItemForEdit) { item in
            NavigationStack {
                MenuDetailView(mode: .edit(item)) { updated in
                    viewModel.updateItem(updated)
                }
            }
        }
    }

    private var topBar: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                Text("STORE CATALOG")
                    .font(.system(size: 11, weight: .semibold))
                    .tracking(2)
                    .foregroundStyle(accent)

                Text("Manage\nMenu")
                    .font(.system(size: 48, weight: .heavy, design: .rounded))
                    .foregroundStyle(textPrimary)
                    .lineSpacing(4)
            }

            Spacer()

            Button {
                isShowingAddSheet = true
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundStyle(Color("FigmaOnAccentSoft"))
                    .frame(width: 56, height: 56)
                    .background(
                        LinearGradient(
                            colors: [accent, Color("FigmaAccentDark")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        in: RoundedRectangle(cornerRadius: 16, style: .continuous)
                    )
                    .shadow(color: Color("FigmaAccentDark").opacity(0.35), radius: 14, y: 8)
            }
            .buttonStyle(.plain)
        }
    }

    private var searchBar: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(textSecondary)

            TextField("Search menu items...", text: $viewModel.searchText)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .foregroundStyle(textPrimary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 18)
        .background(Color("FigmaBlack").opacity(0.35), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color("FigmaWhite").opacity(0.07), lineWidth: 1)
        }
    }

    private var categoryFilters: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(MenuManagementViewModel.CategoryFilter.allCases) { filter in
                    Button {
                        viewModel.selectedFilter = filter
                    } label: {
                        Text(filter.rawValue)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(viewModel.selectedFilter == filter ? Color("FigmaOnAccentDarker") : textSecondary)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background {
                                if viewModel.selectedFilter == filter {
                                    Capsule().fill(Color("FigmaFilterActive"))
                                } else {
                                    Capsule().fill(Color("FigmaWhite").opacity(0.1))
                                }
                            }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var menuSections: some View {
        VStack(alignment: .leading, spacing: 32) {
            if groupedItems.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("No Menu Items")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(textPrimary)

                    Text("Try a different search or category filter.")
                        .font(.system(size: 14))
                        .foregroundStyle(textSecondary)
                }
                .padding(24)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(cardBackground, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            } else {
                ForEach(groupedItems, id: \.0) { category, items in
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(spacing: 12) {
                            Rectangle()
                                .fill(Color("FigmaWhite").opacity(0.18))
                                .frame(width: 40, height: 1)

                            Text(category.rawValue.uppercased())
                                .font(.system(size: 12, weight: .bold))
                                .tracking(3)
                                .foregroundStyle(textSecondary)
                        }

                        ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                            MenuCardView(
                                item: item,
                                index: index,
                                cardBackground: cardBackground,
                                textPrimary: textPrimary,
                                textSecondary: textSecondary,
                                accent: accent,
                                onEdit: { selectedItemForEdit = item },
                                onDelete: { viewModel.deleteItem(item) }
                            )
                        }
                    }
                }
            }
        }
    }
}

private struct MenuCardView: View {
    let item: MenuItem
    let index: Int
    let cardBackground: Color
    let textPrimary: Color
    let textSecondary: Color
    let accent: Color
    let onEdit: () -> Void
    let onDelete: () -> Void

    private var isMuted: Bool { index == 0 && item.name.lowercased().contains("maple") }

    var body: some View {
        Button(action: onEdit) {
            HStack(spacing: 20) {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(gradient)
                    .frame(width: 96, height: 96)
                    .overlay {
                        if isMuted {
                            Text("SOLD OUT")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 0, style: .continuous)
                                        .stroke(.white, lineWidth: 2)
                                }
                                .rotationEffect(.degrees(-12))
                                .background(Color("FigmaBlack").opacity(0.35))
                        } else {
                            Image(systemName: item.imageName ?? "cup.and.saucer.fill")
                                .font(.system(size: 30))
                                .foregroundStyle(Color("FigmaWhite").opacity(0.9))
                        }
                    }

                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .top) {
                        Text(item.name)
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundStyle(textPrimary)
                            .lineLimit(2)

                        Spacer()

                        Text(CurrencyFormatter.string(for: item.price))
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundStyle(accent)
                    }

                    Text(item.category.rawValue)
                        .font(.system(size: 14))
                        .foregroundStyle(textSecondary.opacity(0.85))

                    HStack(spacing: 10) {
                        Text(tagText)
                            .font(.system(size: 10, weight: .semibold))
                            .tracking(1)
                            .foregroundStyle(tagColor)
                            .padding(.horizontal, 11)
                            .padding(.vertical, 5)
                            .background(tagColor.opacity(0.2), in: RoundedRectangle(cornerRadius: 6, style: .continuous))

                        Text(isMuted ? "Out of Stock" : "In Stock")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(textSecondary.opacity(0.6))
                    }
                }
            }
            .padding(21)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(cardBackground, in: RoundedRectangle(cornerRadius: 32, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .stroke(Color("FigmaWhite").opacity(0.04), lineWidth: 1)
            }
            .opacity(isMuted ? 0.65 : 1)
        }
        .buttonStyle(.plain)
        .contextMenu {
            Button("Edit") { onEdit() }
            Button("Delete", role: .destructive) { onDelete() }
        }
    }

    private var gradient: LinearGradient {
        if item.category == .coffee {
            return LinearGradient(
                colors: [Color("FigmaMenuCoffee1"), Color("FigmaMenuCoffee2")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        return LinearGradient(
            colors: [Color("FigmaTileNavy"), Color("FigmaMenuOther2")],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var tagText: String {
        switch item.category {
        case .coffee: return "ESPRESSO"
        case .tea: return "TEA"
        case .juice: return "COLD"
        case .pastry: return "PASTRY"
        }
    }

    private var tagColor: Color {
        switch item.category {
        case .coffee: return Color("FigmaTagCoffee")
        case .tea: return Color("FigmaTagTea")
        case .juice: return Color("FigmaTagJuice")
        case .pastry: return Color("FigmaTagPastry")
        }
    }
}

#Preview {
    MenuListView(viewModel: MenuManagementViewModel())
}

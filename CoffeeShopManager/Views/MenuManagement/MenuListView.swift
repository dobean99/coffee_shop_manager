import SwiftUI

struct MenuListView: View {
    @ObservedObject var viewModel: MenuManagementViewModel

    @State private var selectedItemForEdit: MenuItem?
    @State private var isShowingAddSheet = false

    var body: some View {
        NavigationStack {
            List {
                filterSection

                Section("Menu Items") {
                    if viewModel.filteredItems.isEmpty {
                        ContentUnavailableView(
                            "No Menu Items",
                            systemImage: "magnifyingglass",
                            description: Text("Try a different search or category filter.")
                        )
                    } else {
                        ForEach(viewModel.filteredItems) { item in
                            Button {
                                selectedItemForEdit = item
                            } label: {
                                MenuRowView(item: item)
                            }
                            .buttonStyle(.plain)
                            .contextMenu {
                                Button("Edit") {
                                    selectedItemForEdit = item
                                }
                                Button("Delete", role: .destructive) {
                                    viewModel.deleteItem(item)
                                }
                            }
                        }
                        .onDelete { indexSet in
                            let itemsToDelete: [MenuItem] = indexSet.map { index in
                                viewModel.filteredItems[index]
                            }
                            viewModel.deleteItems(itemsToDelete)
                        }
                    }
                }
            }
            .navigationTitle("Menu Management")
            .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        isShowingAddSheet = true
                    }
                }
            }
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
    }

    private var filterSection: some View {
        Section("Filter") {
            Picker("Category", selection: $viewModel.selectedFilter) {
                ForEach(MenuManagementViewModel.CategoryFilter.allCases) { filter in
                    Text(filter.rawValue).tag(filter)
                }
            }
            .pickerStyle(.segmented)
        }
    }
}

private struct MenuRowView: View {
    let item: MenuItem

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: item.imageName ?? "cup.and.saucer.fill")
                .font(.title3)
                .foregroundStyle(.brown)
                .frame(width: 36, height: 36)
                .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 10, style: .continuous))

            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text(item.category.rawValue)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(CurrencyFormatter.string(for: item.price))
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    MenuListView(viewModel: MenuManagementViewModel())
}

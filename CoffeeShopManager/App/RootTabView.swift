import SwiftUI

struct RootTabView: View {
    @StateObject private var posViewModel: CoffeePOSViewModel
    @StateObject private var menuManagementViewModel: MenuManagementViewModel
    @StateObject private var inventoryViewModel: InventoryViewModel
    @StateObject private var dashboardViewModel: DashboardViewModel

    init(
        menuManagementViewModel: MenuManagementViewModel = MenuManagementViewModel(),
        inventoryViewModel: InventoryViewModel = InventoryViewModel()
    ) {
        let sharedMenuViewModel = menuManagementViewModel
        let sharedInventoryViewModel = inventoryViewModel
        _menuManagementViewModel = StateObject(wrappedValue: sharedMenuViewModel)
        let sharedPOSViewModel = CoffeePOSViewModel(menuManagementViewModel: sharedMenuViewModel)
        _posViewModel = StateObject(wrappedValue: sharedPOSViewModel)
        _inventoryViewModel = StateObject(wrappedValue: sharedInventoryViewModel)
        _dashboardViewModel = StateObject(
            wrappedValue: DashboardViewModel(
                posViewModel: sharedPOSViewModel,
                menuManagementViewModel: sharedMenuViewModel,
                inventoryViewModel: sharedInventoryViewModel
            )
        )
    }

    var body: some View {
        TabView {
            CoffeePOSView(viewModel: posViewModel)
                .tabItem {
                    Label("POS", systemImage: "cart")
                }

            DashboardView(viewModel: dashboardViewModel)
                .tabItem {
                    Label("Dashboard", systemImage: "chart.bar")
                }

            MenuListView(viewModel: menuManagementViewModel)
                .tabItem {
                    Label("Menu", systemImage: "list.bullet.rectangle")
                }

            InventoryView(viewModel: inventoryViewModel)
                .tabItem {
                    Label("Inventory", systemImage: "shippingbox")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .tint(.themeAccent)
        .background(.themeBackground)
        .ignoresSafeArea()
        .toolbarBackground(.themeSurface, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
    }
}

#Preview {
    RootTabView()
}

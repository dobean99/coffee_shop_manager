import SwiftUI

struct RootTabView: View {
    @StateObject private var posViewModel: CoffeePOSViewModel
    @StateObject private var menuManagementViewModel: MenuManagementViewModel
    @StateObject private var inventoryViewModel: InventoryViewModel
    @StateObject private var dashboardViewModel: DashboardViewModel
    @State private var selectedTab: AppTab = .pos

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
        ZStack {
            LinearGradient(
                colors: [Color("FigmaBackground"), Color("FigmaBackgroundDeep")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            currentTabView
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            CustomTabBar(selectedTab: $selectedTab)
        }
        .tint(Color("FigmaAccent"))
    }

    @ViewBuilder
    private var currentTabView: some View {
        switch selectedTab {
        case .pos:
            CoffeePOSView(viewModel: posViewModel)
        case .insight:
            DashboardView(viewModel: dashboardViewModel)
        case .menu:
            MenuListView(viewModel: menuManagementViewModel)
        case .stock:
            InventoryView(viewModel: inventoryViewModel)
        case .admin:
            SettingsView()
        }
    }
}

private enum AppTab: String, CaseIterable, Identifiable {
    case pos = "POS"
    case insight = "INSIGHT"
    case menu = "MENU"
    case stock = "STOCK"
    case admin = "ADMIN"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .pos: return "storefront"
        case .insight: return "chart.bar"
        case .menu: return "cup.and.saucer"
        case .stock: return "archivebox"
        case .admin: return "gearshape"
        }
    }
}

private struct CustomTabBar: View {
    @Binding var selectedTab: AppTab

    var body: some View {
        HStack(spacing: 6) {
            ForEach(AppTab.allCases) { tab in
                Button {
                    selectedTab = tab
                } label: {
                    VStack(spacing: 5) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 17, weight: .semibold))
                            .frame(width: 20, height: 20)

                        Text(tab.rawValue)
                            .font(.system(size: 9, weight: .semibold, design: .rounded))
                            .tracking(1.0)
                    }
                    .foregroundStyle(selectedTab == tab ? Color("FigmaOnAccentDeep") : Color("FigmaTextSecondary"))
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background {
                        if selectedTab == tab {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: [Color("FigmaAccent"), Color("FigmaAccentDark")],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .shadow(color: Color("FigmaAccentDark").opacity(0.35), radius: 16, y: 6)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 10)
        .padding(.bottom, 12)
        .background(.themeBackground)
    }
}

#Preview {
    RootTabView()
}


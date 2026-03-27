import Combine
import Foundation

final class DashboardViewModel: ObservableObject {
    @Published private(set) var todayMetric: DailyMetric
    @Published private(set) var topSellingDrinks: [DrinkSales]
    @Published private(set) var revenueByHour: [RevenuePoint]
    @Published private(set) var menuItemCount: Int
    @Published private(set) var lowStockCount: Int

    private var cancellables = Set<AnyCancellable>()

    init() {
        self.todayMetric = DashboardViewModel.mockTodayMetric
        self.topSellingDrinks = DashboardViewModel.mockTopSellingDrinks
        self.revenueByHour = DashboardViewModel.mockRevenueByHour
        self.menuItemCount = DashboardViewModel.mockMenuItemCount
        self.lowStockCount = DashboardViewModel.mockLowStockCount
    }

    init(
        posViewModel: CoffeePOSViewModel,
        menuManagementViewModel: MenuManagementViewModel,
        inventoryViewModel: InventoryViewModel
    ) {
        self.todayMetric = DailyMetric(revenue: 0, orderCount: 0)
        self.topSellingDrinks = []
        self.revenueByHour = []
        self.menuItemCount = menuManagementViewModel.menuItems.count
        self.lowStockCount = inventoryViewModel.lowStockItems.count

        bindPOS(posViewModel)
        bindMenu(menuManagementViewModel)
        bindInventory(inventoryViewModel)
    }

    var totalRevenueToday: Decimal {
        todayMetric.revenue
    }

    var ordersToday: Int {
        todayMetric.orderCount
    }

    private func bindPOS(_ posViewModel: CoffeePOSViewModel) {
        posViewModel.$completedOrders
            .sink { [weak self] orders in
                self?.recomputeMetrics(from: orders)
            }
            .store(in: &cancellables)
    }

    private func bindMenu(_ menuManagementViewModel: MenuManagementViewModel) {
        menuManagementViewModel.$menuItems
            .map(\.count)
            .assign(to: &$menuItemCount)
    }

    private func bindInventory(_ inventoryViewModel: InventoryViewModel) {
        inventoryViewModel.$items
            .map { items in
                items.filter(\.isLowStock).count
            }
            .assign(to: &$lowStockCount)
    }

    private func recomputeMetrics(from orders: [POSCompletedOrder]) {
        let calendar = Calendar.current
        let todayOrders = orders.filter { calendar.isDateInToday($0.createdAt) }

        let revenue = todayOrders.reduce(Decimal(0)) { partial, order in
            partial + order.totalAmount
        }

        todayMetric = DailyMetric(revenue: revenue, orderCount: todayOrders.count)

        var topSalesMap: [String: Int] = [:]
        for order in todayOrders {
            for line in order.lines {
                topSalesMap[line.drinkName, default: 0] += line.quantity
            }
        }

        topSellingDrinks = topSalesMap
            .sorted { lhs, rhs in
                if lhs.value == rhs.value { return lhs.key < rhs.key }
                return lhs.value > rhs.value
            }
            .prefix(5)
            .map { DrinkSales(drinkName: $0.key, unitsSold: $0.value) }

        var hourlyRevenue: [Int: Decimal] = [:]
        for order in todayOrders {
            let hour = calendar.component(.hour, from: order.createdAt)
            hourlyRevenue[hour, default: 0] += order.totalAmount
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "ha"

        revenueByHour = hourlyRevenue
            .sorted { $0.key < $1.key }
            .map { hour, revenue in
                var components = DateComponents()
                components.hour = hour
                let date = calendar.date(from: components) ?? Date()
                let label = formatter.string(from: date)
                return RevenuePoint(hourLabel: label, revenue: revenue)
            }
    }

    private static let mockTodayMetric = DailyMetric(
        revenue: 1834.50,
        orderCount: 142
    )

    private static let mockTopSellingDrinks: [DrinkSales] = [
        DrinkSales(drinkName: "Latte", unitsSold: 38),
        DrinkSales(drinkName: "Americano", unitsSold: 30),
        DrinkSales(drinkName: "Cappuccino", unitsSold: 24),
        DrinkSales(drinkName: "Matcha Latte", unitsSold: 19),
        DrinkSales(drinkName: "Cold Brew", unitsSold: 17)
    ]

    private static let mockRevenueByHour: [RevenuePoint] = [
        RevenuePoint(hourLabel: "8AM", revenue: 120),
        RevenuePoint(hourLabel: "9AM", revenue: 180),
        RevenuePoint(hourLabel: "10AM", revenue: 240),
        RevenuePoint(hourLabel: "11AM", revenue: 280),
        RevenuePoint(hourLabel: "12PM", revenue: 320),
        RevenuePoint(hourLabel: "1PM", revenue: 260),
        RevenuePoint(hourLabel: "2PM", revenue: 210),
        RevenuePoint(hourLabel: "3PM", revenue: 224.5)
    ]

    private static let mockMenuItemCount = 18
    private static let mockLowStockCount = 2
}

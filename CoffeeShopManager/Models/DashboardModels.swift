import Foundation

struct DailyMetric {
    let revenue: Decimal
    let orderCount: Int
}

struct DrinkSales: Identifiable {
    let id: UUID
    let drinkName: String
    let unitsSold: Int

    init(id: UUID = UUID(), drinkName: String, unitsSold: Int) {
        self.id = id
        self.drinkName = drinkName
        self.unitsSold = unitsSold
    }
}

struct RevenuePoint: Identifiable {
    let id: UUID
    let hourLabel: String
    let revenue: Decimal

    init(id: UUID = UUID(), hourLabel: String, revenue: Decimal) {
        self.id = id
        self.hourLabel = hourLabel
        self.revenue = revenue
    }
}

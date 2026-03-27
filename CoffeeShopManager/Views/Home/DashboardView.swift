import Charts
import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel: DashboardViewModel

    init(viewModel: DashboardViewModel = DashboardViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    KPISectionView(
                        totalRevenue: viewModel.totalRevenueToday,
                        ordersToday: viewModel.ordersToday,
                        menuItemCount: viewModel.menuItemCount,
                        lowStockCount: viewModel.lowStockCount
                    )

                    RevenueChartCardView(points: viewModel.revenueByHour)

                    TopSellingCardView(drinks: viewModel.topSellingDrinks)
                }
                .padding(16)
            }
            .background(.themeBackground)
            .navigationTitle("Dashboard")
        }
    }
}

private struct KPISectionView: View {
    let totalRevenue: Decimal
    let ordersToday: Int
    let menuItemCount: Int
    let lowStockCount: Int

    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            DashboardStatCard(
                title: "Revenue Today",
                value: CurrencyFormatter.string(for: totalRevenue),
                systemImage: "dollarsign.circle.fill",
                accent: .green
            )

            DashboardStatCard(
                title: "Orders",
                value: "\(ordersToday)",
                systemImage: "bag.fill",
                accent: .blue
            )

            DashboardStatCard(
                title: "Menu Items",
                value: "\(menuItemCount)",
                systemImage: "list.bullet.rectangle",
                accent: .brown
            )

            DashboardStatCard(
                title: "Low Stock",
                value: "\(lowStockCount)",
                systemImage: "exclamationmark.triangle.fill",
                accent: .orange
            )
        }
    }
}

private struct DashboardStatCard: View {
    let title: String
    let value: String
    let systemImage: String
    let accent: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: systemImage)
                .font(.title2)
                .foregroundStyle(accent)

            Text(title)
                .font(.subheadline)
                .foregroundStyle(.themeSubtext)

            Text(value)
                .font(.title2.bold())
                .foregroundStyle(.themeText)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(.themeSurface, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

private struct RevenueChartCardView: View {
    let points: [RevenuePoint]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Revenue by Hour")
                .font(.headline)

            Chart(points) { point in
                BarMark(
                    x: .value("Hour", point.hourLabel),
                    y: .value("Revenue", (point.revenue as NSDecimalNumber).doubleValue)
                )
                .foregroundStyle(.themePrimary.gradient)
                .cornerRadius(4)
            }
            .frame(height: 220)
            .chartYAxis {
                AxisMarks(position: .leading)
            }
        }
        .padding(16)
        .background(.themeSurface, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

private struct TopSellingCardView: View {
    let drinks: [DrinkSales]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Top-Selling Drinks")
                .font(.headline)

            ForEach(Array(drinks.enumerated()), id: \.element.id) { index, drink in
                HStack {
                    Text("#\(index + 1)")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.themeSubtext)
                        .frame(width: 32, alignment: .leading)

                    Text(drink.drinkName)
                        .font(.body.weight(.medium))

                    Spacer()

                    Text("\(drink.unitsSold) sold")
                        .font(.subheadline)
                        .foregroundStyle(.themeSubtext)
                }
                .padding(.vertical, 4)

                if drink.id != drinks.last?.id {
                    Divider()
                }
            }
        }
        .padding(16)
        .background(.themeSurface, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

#Preview {
    DashboardView()
}

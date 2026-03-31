import Charts
import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel: DashboardViewModel

    init(viewModel: DashboardViewModel = DashboardViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    private let pageBackground = Color("FigmaBackground")
    private let cardBackground = Color("FigmaCard")
    private let textPrimary = Color("FigmaTextPrimary")
    private let textSecondary = Color("FigmaTextSecondary")
    private let accent = Color("FigmaAccent")

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                topBar
                welcomeSection
                lowStockBanner
                summaryCards
                salesCard
                highlightsSection
            }
            .padding(.horizontal, 24)
            .padding(.top, 12)
            .padding(.bottom, 140)
        }
        .background(pageBackground.ignoresSafeArea())
    }

    private var topBar: some View {
        HStack {
            HStack(spacing: 12) {
                Circle()
                    .fill(Color("FigmaWhite").opacity(0.14))
                    .frame(width: 40, height: 40)
                    .overlay {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(textSecondary)
                    }

                Text("The Roastery")
                    .font(.system(size: 22, weight: .heavy, design: .rounded))
                    .foregroundStyle(textPrimary)
            }

            Spacer()

            HStack(spacing: 4) {
                Image(systemName: "magnifyingglass")
                Image(systemName: "bell")
            }
            .font(.system(size: 16, weight: .semibold))
            .foregroundStyle(accent)
        }
    }

    private var welcomeSection: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(Date.now.formatted(.dateTime.weekday(.wide).month(.abbreviated).day()))
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(textSecondary)

            Text("Daily Pulse")
                .font(.system(size: 46, weight: .heavy, design: .rounded))
                .foregroundStyle(textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
    }

    private var lowStockBanner: some View {
        HStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(accent.opacity(0.18))
                .frame(width: 44, height: 44)
                .overlay {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundStyle(accent)
                }

            VStack(alignment: .leading, spacing: 2) {
                Text("Inventory Alert")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(accent)

                Text(viewModel.lowStockCount == 0 ? "All inventory levels look healthy." : "\(viewModel.lowStockCount) item(s) are critically low (below 15%).")
                    .font(.system(size: 12))
                    .foregroundStyle(textSecondary)
                    .lineLimit(3)
            }

            Spacer(minLength: 10)

            Text("RESTOCK")
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(accent)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(accent.opacity(0.12), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
        .padding(17)
        .background(Color("FigmaBanner"), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(accent.opacity(0.2), lineWidth: 1)
        }
    }

    private var summaryCards: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 18) {
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("DAILY REVENUE")
                            .font(.system(size: 10, weight: .semibold))
                            .tracking(1.4)
                            .foregroundStyle(textSecondary)

                        Text(CurrencyFormatter.string(for: viewModel.totalRevenueToday))
                            .font(.system(size: 46, weight: .heavy, design: .rounded))
                            .foregroundStyle(accent)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                    }

                    Spacer()

                    HStack(spacing: 4) {
                        Image(systemName: "arrow.up.right")
                        Text("12.5%")
                    }
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(Color("FigmaSuccess"))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.green.opacity(0.18), in: Capsule())
                }

                HStack(alignment: .bottom, spacing: 6) {
                    ForEach(Array(viewModel.revenueByHour.prefix(7).enumerated()), id: \.offset) { index, point in
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .fill(index >= 4 ? accent.opacity(0.85) : Color("FigmaWhite").opacity(0.1))
                            .frame(maxWidth: .infinity)
                            .frame(height: max(16, CGFloat((point.revenue as NSDecimalNumber).doubleValue / 9)))
                    }
                }
                .frame(height: 64, alignment: .bottom)
            }
            .padding(25)
            .background(cardBackground, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color("FigmaWhite").opacity(0.06), lineWidth: 1)
            }

            HStack(spacing: 16) {
                compactKPI(title: "TRANSACTIONS", value: "\(viewModel.ordersToday)", subtitle: "Orders")
                compactKPI(title: "AVG ORDER", value: averageOrderValue)
            }
        }
    }

    private var salesCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Sales Performance")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(textPrimary)

                Spacer()

                HStack(spacing: 0) {
                    Text("HOURLY")
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundStyle(accent)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color("FigmaWhite").opacity(0.08), in: RoundedRectangle(cornerRadius: 6, style: .continuous))

                    Text("DAILY")
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundStyle(textSecondary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                }
                .padding(2)
                .background(Color("FigmaWhite").opacity(0.06), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
            }

            Chart(Array(viewModel.revenueByHour.enumerated()), id: \.offset) { _, point in
                AreaMark(
                    x: .value("Hour", point.hourLabel),
                    y: .value("Revenue", (point.revenue as NSDecimalNumber).doubleValue)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(
                    LinearGradient(
                        colors: [accent.opacity(0.5), accent.opacity(0.02)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

                LineMark(
                    x: .value("Hour", point.hourLabel),
                    y: .value("Revenue", (point.revenue as NSDecimalNumber).doubleValue)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(accent)
                .lineStyle(StrokeStyle(lineWidth: 2))
            }
            .chartYAxis(.hidden)
            .chartXAxis {
                AxisMarks(stroke: StrokeStyle(lineWidth: 0))
            }
            .frame(height: 176)
        }
        .padding(25)
        .background(cardBackground, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color("FigmaWhite").opacity(0.06), lineWidth: 1)
        }
    }

    private var highlightsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Menu Highlights")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundStyle(textPrimary)

                Spacer()

                Text("Full Report")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(accent)
            }

            ForEach(Array(viewModel.topSellingDrinks.prefix(2).enumerated()), id: \.element.id) { index, drink in
                VStack(spacing: 10) {
                    HStack {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color("FigmaWhite").opacity(0.08))
                            .frame(width: 48, height: 48)
                            .overlay {
                                Image(systemName: index == 0 ? "cup.and.saucer" : "birthday.cake")
                                    .foregroundStyle(textSecondary)
                            }

                        VStack(alignment: .leading, spacing: 2) {
                            Text(drink.drinkName)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(textPrimary)
                                .lineLimit(1)

                            Text("\(drink.unitsSold) orders")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundStyle(accent)
                        }

                        Spacer()
                    }

                    GeometryReader { proxy in
                        let percent = max(0.08, min(1.0, CGFloat(drink.unitsSold) / CGFloat(max(1, (viewModel.topSellingDrinks.first?.unitsSold ?? 1)))))
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 99, style: .continuous)
                                .fill(Color("FigmaWhite").opacity(0.09))
                                .frame(height: 8)

                            RoundedRectangle(cornerRadius: 99, style: .continuous)
                                .fill(accent)
                                .frame(width: proxy.size.width * percent, height: 8)
                        }
                    }
                    .frame(height: 8)
                }
                .padding(17)
                .background(cardBackground, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
        }
    }

    private func compactKPI(title: String, value: String, subtitle: String? = nil) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 10, weight: .semibold))
                .tracking(1.4)
                .foregroundStyle(textSecondary)

            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text(value)
                    .font(.system(size: 36, weight: .heavy, design: .rounded))
                    .foregroundStyle(textPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)

                if let subtitle {
                    Text(subtitle)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(textSecondary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(21)
        .background(cardBackground, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color("FigmaWhite").opacity(0.06), lineWidth: 1)
        }
    }

    private var averageOrderValue: String {
        guard viewModel.ordersToday > 0 else { return "$0.00" }
        return CurrencyFormatter.string(for: viewModel.totalRevenueToday / Decimal(viewModel.ordersToday))
    }
}

#Preview {
    DashboardView()
}

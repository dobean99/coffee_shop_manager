import SwiftUI

struct CoffeePOSView: View {
    @ObservedObject var viewModel: CoffeePOSViewModel
    @State private var selectedCategory: String = "All"

    private let gridColumns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    private let pageBackground = Color("FigmaBackground")
    private let cardBackground = Color("FigmaCard")
    private let accent = Color("FigmaAccent")
    private let textPrimary = Color("FigmaTextPrimary")
    private let textSecondary = Color("FigmaTextSecondary")

    private var categories: [String] {
        ["All"] + Array(Set(viewModel.drinks.map(\.category))).sorted()
    }

    private var filteredDrinks: [POSDrinkItem] {
        guard selectedCategory != "All" else { return viewModel.drinks }
        return viewModel.drinks.filter { $0.category == selectedCategory }
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {
                topBar
                categoryChips
                drinkGrid
                cartBar
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 120)
        }
        .background(pageBackground.ignoresSafeArea())
        .onAppear {
            if !categories.contains(selectedCategory) {
                selectedCategory = "All"
            }
        }
        .sheet(item: $viewModel.activePayment, onDismiss: viewModel.clearActivePayment) { payment in
            CheckoutSuccessView(payment: payment) {
                viewModel.clearActivePayment()
            }
        }
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

            Image(systemName: "bell")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(accent)
        }
    }

    private var categoryChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(categories, id: \.self) { category in
                    Button {
                        selectedCategory = category
                    } label: {
                        Text(category)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(selectedCategory == category ? Color("FigmaOnAccent") : textSecondary)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 10)
                            .background {
                                if selectedCategory == category {
                                    Capsule()
                                        .fill(
                                            LinearGradient(
                                                colors: [accent, Color("FigmaAccentDark")],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                } else {
                                    Capsule().fill(Color("FigmaWhite").opacity(0.09))
                                }
                            }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical, 2)
        }
    }

    private var drinkGrid: some View {
        LazyVGrid(columns: gridColumns, spacing: 16) {
            ForEach(Array(filteredDrinks.enumerated()), id: \.element.id) { index, drink in
                VStack(alignment: .leading, spacing: 12) {
                    ZStack(alignment: .bottomTrailing) {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(tileGradient(index: index))
                            .frame(height: 145)
                            .overlay {
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .stroke(Color("FigmaWhite").opacity(0.06), lineWidth: 1)
                            }

                        if drink.name.lowercased().contains("spiced") || drink.name.lowercased().contains("season") {
                            Text("NEW")
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundStyle(accent)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color("FigmaBadgeWarm"), in: RoundedRectangle(cornerRadius: 6, style: .continuous))
                                .padding(.trailing, 56)
                                .padding(.bottom, 8)
                        }

                        Button {
                            viewModel.addToCart(drink)
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(Color("FigmaOnAccent"))
                                .frame(width: 40, height: 40)
                                .background(accent, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                        }
                        .buttonStyle(.plain)
                        .padding(8)
                    }

                    Text(drink.name)
                        .font(.system(size: 19, weight: .bold, design: .rounded))
                        .foregroundStyle(textPrimary)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)

                    Text(CurrencyFormatter.string(for: drink.price))
                        .font(.system(size: 33, weight: .medium))
                        .foregroundStyle(textSecondary)
                }
                .padding(13)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(cardBackground, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color("FigmaWhite").opacity(0.04), lineWidth: 1)
                }
            }
        }
    }

    private var cartBar: some View {
        HStack(spacing: 16) {
            HStack(spacing: 12) {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: "cart")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(accent)

                    if viewModel.totalQuantity > 0 {
                        Text("\(viewModel.totalQuantity)")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(Color("FigmaCartBadgeText"))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(accent, in: Capsule())
                            .offset(x: 10, y: -10)
                    }
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text("\(viewModel.totalQuantity) Items")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(textPrimary)

                    Text("\(CurrencyFormatter.string(for: viewModel.totalPrice)) Subtotal")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(textSecondary)
                }
            }

            Spacer()

            Button {
                viewModel.checkout()
            } label: {
                Text("CHECKOUT")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(Color("FigmaOnAccent"))
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
                    .background(accent, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
            .buttonStyle(.plain)
            .disabled(viewModel.cartItems.isEmpty)
            .opacity(viewModel.cartItems.isEmpty ? 0.45 : 1)
        }
        .padding(17)
        .background(Color("FigmaWhite").opacity(0.09), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color("FigmaWhite").opacity(0.08), lineWidth: 1)
        }
    }

    private func tileGradient(index: Int) -> some ShapeStyle {
        LinearGradient(
            colors: index.isMultiple(of: 2)
                ? [Color("FigmaTileBrown"), Color("FigmaTileBlue")]
                : [Color("FigmaTileNavy"), Color("FigmaTileCopper")],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

#Preview {
    CoffeePOSView(viewModel: CoffeePOSViewModel())
}

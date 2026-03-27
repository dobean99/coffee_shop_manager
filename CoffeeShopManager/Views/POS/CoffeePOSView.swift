import SwiftUI

struct CoffeePOSView: View {
    @ObservedObject var viewModel: CoffeePOSViewModel

    private let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 12)
    ]

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(viewModel.drinks) { drink in
                                DrinkTileView(drink: drink) {
                                    viewModel.addToCart(drink)
                                }
                            }
                        }
                        .padding(16)
                    }
                    .frame(maxWidth: .infinity)

                    Divider()

                    POSCartPanelView(
                        items: viewModel.cartItems,
                        totalPrice: viewModel.totalPrice,
                        totalQuantity: viewModel.totalQuantity,
                        onIncrease: viewModel.increaseQuantity,
                        onDecrease: viewModel.decreaseQuantity,
                        onCheckout: viewModel.checkout
                    )
                    .frame(width: max(300, geometry.size.width * 0.36))
                }
            }
            .navigationTitle("Coffee POS")
        }
    }
}

#Preview {
    CoffeePOSView(viewModel: CoffeePOSViewModel())
}

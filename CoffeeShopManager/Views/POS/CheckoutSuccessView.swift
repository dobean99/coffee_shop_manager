import SwiftUI

struct CheckoutSuccessView: View {
    @StateObject private var viewModel: CheckoutSuccessViewModel
    let onPaid: () -> Void

    @Environment(\.dismiss) private var dismiss

    init(payment: QRPaymentInfo, onPaid: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: CheckoutSuccessViewModel(payment: payment))
        self.onPaid = onPaid
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text(CurrencyFormatter.string(for: viewModel.payment.amount))
                        .font(.system(size: 42, weight: .bold))
                        .foregroundStyle(Color("ThemePrimary"))

                    VStack(spacing: 8) {
                        Text("Scan to pay")
                            .font(.headline)

                        if let image = viewModel.qrImage {
                            Image(uiImage: image)
                                .interpolation(.none)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 260, height: 260)
                                .padding(12)
                                .background(Color("ThemeSurface"), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                        } else {
                            ContentUnavailableView("QR unavailable", systemImage: "qrcode")
                        }
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        paymentRow(title: "Bank", value: viewModel.payment.bankName)
                        paymentRow(title: "Account", value: viewModel.payment.accountNumber)
                        paymentRow(title: "Content", value: viewModel.payment.transferContent)
                        paymentRow(title: "Time left", value: viewModel.formattedCountdown)
                            .foregroundStyle(viewModel.isExpired ? .red : Color("ThemeText"))
                    }
                    .padding(16)
                    .background(Color("ThemeSurface"), in: RoundedRectangle(cornerRadius: 16, style: .continuous))

                    Button("I have paid") {
                        viewModel.markPaid()
                        onPaid()
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .disabled(viewModel.isExpired)
                }
                .frame(maxWidth: .infinity)
                .padding(20)
            }
            .background(Color("ThemeBackground"))
            .navigationTitle("Payment QR")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func paymentRow(title: String, value: String) -> some View {
        HStack(alignment: .top) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .frame(width: 90, alignment: .leading)
                .foregroundStyle(Color("ThemeSubtext"))
            Text(value)
                .font(.subheadline)
            Spacer(minLength: 0)
        }
    }
}

#Preview {
    CheckoutSuccessView(
        payment: QRPaymentInfo(
            id: "ORDER-123456",
            amount: 124_000,
            bankName: "Vietcombank",
            bankBin: "970436",
            accountNumber: "00110011999",
            transferContent: "ORDER-123456"
        ),
        onPaid: {}
    )
}

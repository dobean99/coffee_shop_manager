import Combine
import UIKit

final class CheckoutSuccessViewModel: ObservableObject {
    @Published private(set) var secondsRemaining: Int = 300
    @Published private(set) var isPaid = false

    let payment: QRPaymentInfo
    let qrImage: UIImage?

    private var timerCancellable: AnyCancellable?

    init(payment: QRPaymentInfo) {
        self.payment = payment
        self.qrImage = QRCodeGenerator.generateImage(from: payment.qrContent)
        startCountdown()
    }

    var formattedCountdown: String {
        let minutes = secondsRemaining / 60
        let seconds = secondsRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var isExpired: Bool {
        secondsRemaining <= 0
    }

    func markPaid() {
        isPaid = true
        timerCancellable?.cancel()
    }

    private func startCountdown() {
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                guard secondsRemaining > 0 else {
                    timerCancellable?.cancel()
                    return
                }
                secondsRemaining -= 1
            }
    }
}

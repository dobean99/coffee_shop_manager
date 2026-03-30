import Foundation

struct QRPaymentInfo: Identifiable, Hashable {
    let id: String
    let amount: Decimal
    let bankName: String
    let bankBin: String
    let accountNumber: String
    let transferContent: String
    let merchantName: String
    let city: String

    init(
        id: String,
        amount: Decimal,
        bankName: String,
        bankBin: String,
        accountNumber: String,
        transferContent: String,
        merchantName: String = "COFFEE SHOP MANAGER",
        city: String = "HO CHI MINH"
    ) {
        self.id = id
        self.amount = amount
        self.bankName = bankName
        self.bankBin = bankBin
        self.accountNumber = accountNumber
        self.transferContent = transferContent
        self.merchantName = merchantName
        self.city = city
    }

    var qrContent: String {
        VietQRPayloadBuilder.build(for: self)
    }
}

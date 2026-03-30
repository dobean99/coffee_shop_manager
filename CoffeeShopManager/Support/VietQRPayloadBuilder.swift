import Foundation

enum VietQRPayloadBuilder {
    static func build(for payment: QRPaymentInfo) -> String {
        let merchantInfo = buildMerchantAccountInfo(
            bankBin: payment.bankBin,
            accountNumber: payment.accountNumber
        )

        let additionalData = tlv("08", payment.transferContent)

        var payload = ""
        payload += tlv("00", "01") // Payload Format Indicator
        payload += tlv("01", "12") // Dynamic QR
        payload += tlv("38", merchantInfo) // Merchant account info for VietQR
        payload += tlv("53", "704") // VND
        payload += tlv("54", formatAmount(payment.amount))
        payload += tlv("58", "VN")
        payload += tlv("59", payment.merchantName)
        payload += tlv("60", payment.city)
        payload += tlv("62", additionalData)

        let crcInput = payload + "6304"
        let crc = crc16CCITTFalse(crcInput)
        payload += "63" + "04" + String(format: "%04X", crc)
        return payload
    }

    private static func buildMerchantAccountInfo(bankBin: String, accountNumber: String) -> String {
        let beneficiary = tlv("00", bankBin) + tlv("01", accountNumber)
        return tlv("00", "A000000727")
        + tlv("01", beneficiary)
        + tlv("02", "QRIBFTTA")
    }

    private static func tlv(_ tag: String, _ value: String) -> String {
        let length = value.count
        return tag + String(format: "%02d", length) + value
    }

    private static func formatAmount(_ amount: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        formatter.usesGroupingSeparator = false
        return formatter.string(from: amount as NSDecimalNumber) ?? "0"
    }

    private static func crc16CCITTFalse(_ input: String) -> UInt16 {
        let bytes = Array(input.utf8)
        var crc: UInt16 = 0xFFFF

        for byte in bytes {
            crc ^= UInt16(byte) << 8
            for _ in 0..<8 {
                if crc & 0x8000 != 0 {
                    crc = (crc << 1) ^ 0x1021
                } else {
                    crc <<= 1
                }
            }
        }
        return crc
    }
}

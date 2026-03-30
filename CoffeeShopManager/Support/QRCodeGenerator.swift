import CoreImage.CIFilterBuiltins
import SwiftUI
import UIKit

enum QRCodeGenerator {
    private static let context = CIContext()

    static func generateImage(from content: String, dimension: CGFloat = 280) -> UIImage? {
        let filter = CIFilter.qrCodeGenerator()
        filter.message = Data(content.utf8)
        filter.correctionLevel = "M"

        guard let outputImage = filter.outputImage else { return nil }
        let scaleX = dimension / outputImage.extent.size.width
        let scaleY = dimension / outputImage.extent.size.height
        let transformed = outputImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))

        guard let cgImage = context.createCGImage(transformed, from: transformed.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }
}

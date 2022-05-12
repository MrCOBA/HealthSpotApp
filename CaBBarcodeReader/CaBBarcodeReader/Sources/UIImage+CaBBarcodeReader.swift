import UIKit

extension UIImage {

    enum MedicineChecker {

        public static var placeholderIcon: UIImage {
            return UIImage(named: "medicine-\(Int.random(in: 0..<20))",
                           in: .barcodeReader,
                           compatibleWith: nil) ?? UIImage()
        }

    }
}

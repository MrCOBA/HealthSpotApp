import UIKit

extension UIStackView {

    public func removeArrangedSubviews() {
        let subviewsToRemove = arrangedSubviews
        subviewsToRemove.forEach {
            $0.removeFromSuperview()
        }
    }

}

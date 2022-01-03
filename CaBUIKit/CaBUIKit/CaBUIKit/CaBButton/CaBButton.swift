import CaBSDK
import UIKit
import Foundation

@IBDesignable
public class CaBButton: UIButton, CaBUIControl {

    // MARK: - Public Types

    public typealias Action = () -> Void

    // MARK: - Public Methods

    public func apply(configuration: CaBUIConfiguration) {
        configureFont(with: configuration)
        configureColors(with: configuration)
        configureBorder(with: configuration)
    }

    public func handle(action: @escaping Action) {
        DispatchQueue.main.async {
            action()
        }
    }

    // MARK: - Private Methods
    
    private func configureFont(with configuration: CaBUIConfiguration) {
        titleLabel?.font = UIFontMetrics.default.scaledFont(for: configuration.font)
        titleLabel?.adjustsFontForContentSizeCategory = true
    }

    private func configureColors(with configuration: CaBUIConfiguration) {
        backgroundColor = configuration.backgroundColor
        setTitleColor(configuration.textColor, for: .normal)
        layer.borderColor = configuration.borderColor?.cgColor
    }

    private func configureBorder(with configuration: CaBUIConfiguration) {
        layer.cornerRadius = configuration.cornerRadius
        layer.borderWidth = configuration.borderWidth
    }

}

import UIKit

public final class CaBTextField: UITextField, CaBUIControl {

    // MARK: - Public Methods

    public func apply(configuration: CaBUIConfiguration) {
        configureColors(with: configuration)
        configureFont(with: configuration)
        configureLayout(with: configuration)
        configureBorder(with: configuration)
    }

    // MARK: - Private Methods

    private func configureColors(with configuration: CaBUIConfiguration) {
        backgroundColor = configuration.backgroundColor
        textColor = configuration.textColor
    }

    private func configureFont(with configuration: CaBUIConfiguration) {
        font = configuration.font
        adjustsFontForContentSizeCategory = true
    }

    private func configureLayout(with configuration: CaBUIConfiguration) {
        layer.cornerRadius = configuration.cornerRadius
    }

    private func configureBorder(with configuration: CaBUIConfiguration) {
        layer.borderWidth = configuration.borderWidth
        layer.borderColor = configuration.borderColor?.cgColor
    }

}

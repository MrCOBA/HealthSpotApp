import UIKit

public final class CaBTextField: UITextField, CaBUIControl {

    // MARK: - Private Types

    private enum Constants {

        static var contentEdgeInsets: UIEdgeInsets {
            return .init(top: 12.0, left: 8.0, bottom: 12.0, right: 8.0)
        }

    }

    // MARK: - Public Methods

    public func apply(configuration: CaBUIConfiguration) {
        configureColors(with: configuration)
        configureFont(with: configuration)
        configureLayout(with: configuration)
        configureBorder(with: configuration)
    }

    // MARK: - Overrides

    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: Constants.contentEdgeInsets)
    }

    override public func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: Constants.contentEdgeInsets)
    }

    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: Constants.contentEdgeInsets)
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

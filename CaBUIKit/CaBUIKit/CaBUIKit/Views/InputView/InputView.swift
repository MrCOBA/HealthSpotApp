import UIKit
import CaBSDK

// MARK: - Delegate

public protocol InputViewDelegate: AnyObject {

    func didEndEditingText(for id: Int, with text: String?)

}

public class InputView: UIView {

    // MARK: - Private Types

    private enum Constant {

        static var stackViewItemSpacing: CGFloat {
            return 8.0
        }

        static var height: CGFloat {
            return 40.0
        }

        static var iconSize: (height: CGFloat, width: CGFloat) {
            return (24.0, 24.0)
        }

    }

    // MARK: - Public Properties

    public let id: Int
    public var delegate: InputViewDelegate?
    public var textField: UITextField? {
        guard let textField = stackView.arrangedSubviews.first as? UITextField else {
            logError(message: "Text field expected to be set")
            return nil
        }

        return textField
    }

    // MARK: - Private Properties

    private let configuration: CaBTextFieldConfiguration
    private let icon: UIImage?
    private let colorScheme: CaBColorScheme

    private let stackView = UIStackView()

    // MARK: - Init

    public init(frame: CGRect, id: Int, configuration: CaBTextFieldConfiguration, icon: UIImage? = nil, colorScheme: CaBColorScheme) {
        self.id = id
        self.configuration = configuration
        self.icon = icon
        self.colorScheme = colorScheme
        super.init(frame: frame)

        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func configure() {
        stackView.axis = .horizontal
        stackView.spacing = Constant.stackViewItemSpacing
        stackView.alignment = .center

        addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.heightAnchor.constraint(equalToConstant: Constant.height),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        stackView.addArrangedSubview(configureTextField())

        guard let imageView = configureIconImageView() else {
            return
        }
        stackView.addArrangedSubview(imageView)
    }

    private func configureTextField() -> UITextField {
        let textField = CaBTextField()
        textField.apply(configuration: configuration)
        textField.delegate = self
        return textField
    }

    private func configureIconImageView() -> UIImageView? {
        guard let icon = icon else {
            return nil
        }

        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: Constant.iconSize.height),
            imageView.widthAnchor.constraint(equalToConstant: Constant.iconSize.width),
        ])

        imageView.image = icon
        imageView.tintColor = colorScheme.attributesTertiaryColor

        return imageView
    }

}

// MARK: - Protocol UITextFieldDelegate

extension InputView: UITextFieldDelegate {

    public func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.didEndEditingText(for: id, with: textField.text)
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return false
    }

}

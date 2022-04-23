import UIKit

public class InputView: UIView {

    // MARK: - Private Types

    private enum Constant {

        static var height: CGFloat {
            return 40.0
        }

        static var iconSize: (height: CGFloat, width: CGFloat) {
            return (24.0, 24.0)
        }

    }

    // MARK: - Private Properties

    private let configuration: CaBTextFieldConfiguration
    private let icon: UIImage?

    private var stackView: UIStackView {
        let originStackView = UIStackView()
        originStackView.axis = .horizontal
        originStackView.distribution = .fill
        originStackView.alignment = .fill
        originStackView.heightAnchor.constraint(equalToConstant: Constant.height).isActive = true

        return originStackView
    }

    // MARK: - Init

    public init(frame: CGRect, configuration: CaBTextFieldConfiguration, icon: UIImage? = nil) {
        self.configuration = configuration
        self.icon = icon
        super.init(frame: frame)

        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func configure() {
        addSubview(stackView)

        NSLayoutConstraint.activate([
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
        return textField
    }

    private func configureIconImageView() -> UIImageView? {
        guard let icon = icon else {
            return nil
        }

        let imageView = UIImageView()

        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: Constant.iconSize.height),
            imageView.heightAnchor.constraint(equalToConstant: Constant.iconSize.width),
        ])

        imageView.image = icon

        return imageView
    }

}

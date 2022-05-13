import UIKit
import CaBUIKit
import CaBSDK

// MARK: - Delegate

protocol CalendarPickerFooterDelegate: AnyObject {

    func didTapPreviousMonthButton()
    func didTapNextMonthButton()

}

final class CalendarPickerFooterView: UIView {

    // MARK: - Private Types

    private enum Constants {

        static var fontSize: CGFloat {
            let smallDevice = UIScreen.main.bounds.width <= 350
            return smallDevice ? 14 : 17
        }

        static var cornerRadius: CGFloat {
            return 8.0
        }

        static var horizontalPadding: CGFloat {
            return 10.0
        }

        static var separatorHeight: CGFloat {
            return 1.0
        }

    }

    // MARK: - Internal Prperties

    var colorScheme: CaBColorScheme = .default
    var delegate: CalendarPickerFooterDelegate?

    // MARK: - Private Properties

    private lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .transparentGray20Alpha
        return view
    }()

    private lazy var previousMonthButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = CaBFont.Comfortaa.medium(size: Constants.fontSize)
        button.titleLabel?.textAlignment = .left

        if let chevronImage = UIImage(systemName: "chevron.left.circle.fill") {
            let imageAttachment = NSTextAttachment(image: chevronImage)
            let attributedString = NSMutableAttributedString()

            attributedString.append(
                NSAttributedString(attachment: imageAttachment)
            )

            attributedString.append(
                NSAttributedString(string: " Previous")
            )

            button.setAttributedTitle(attributedString, for: .normal)
        }
        else {
            button.setTitle("Previous", for: .normal)
        }

        button.titleLabel?.textColor = colorScheme.highlightPrimaryColor

        button.addTarget(self, action: #selector(didTapPreviousMonthButton), for: .touchUpInside)
        return button
    }()

    private lazy var nextMonthButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = CaBFont.Comfortaa.medium(size: Constants.fontSize)
        button.titleLabel?.textAlignment = .right

        if let chevronImage = UIImage(systemName: "chevron.right.circle.fill") {
            let imageAttachment = NSTextAttachment(image: chevronImage)
            let attributedString = NSMutableAttributedString(string: "Next ")

            attributedString.append(
                NSAttributedString(attachment: imageAttachment)
            )

            button.setAttributedTitle(attributedString, for: .normal)
        }
        else {
            button.setTitle("Next", for: .normal)
        }

        button.titleLabel?.textColor = colorScheme.highlightPrimaryColor

        button.addTarget(self, action: #selector(didTapNextMonthButton), for: .touchUpInside)
        return button
    }()

    // MARK: - Init

    init(colorScheme: CaBColorScheme) {
        super.init(frame: CGRect.zero)

        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Internal Methods

    override func layoutSubviews() {
        super.layoutSubviews()

        configureLayout()
    }

    // MARK: - Private Methods

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white

        layer.maskedCorners = [
            .layerMinXMaxYCorner,
            .layerMaxXMaxYCorner
        ]
        layer.cornerCurve = .continuous
        layer.cornerRadius = Constants.cornerRadius

        addSubview(separatorView)
        addSubview(previousMonthButton)
        addSubview(nextMonthButton)
    }

    private func configureLayout() {
        previousMonthButton.titleLabel?.font = CaBFont.Comfortaa.medium(size: Constants.fontSize)
        nextMonthButton.titleLabel?.font = CaBFont.Comfortaa.medium(size: Constants.fontSize)

        configureConstraints()
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.topAnchor.constraint(equalTo: topAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: Constants.separatorHeight),

            previousMonthButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalPadding),
            previousMonthButton.centerYAnchor.constraint(equalTo: centerYAnchor),

            nextMonthButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalPadding),
            nextMonthButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    @objc private func didTapPreviousMonthButton() {
        delegate?.didTapPreviousMonthButton()
    }

    @objc private func didTapNextMonthButton() {
        delegate?.didTapNextMonthButton()
    }

}

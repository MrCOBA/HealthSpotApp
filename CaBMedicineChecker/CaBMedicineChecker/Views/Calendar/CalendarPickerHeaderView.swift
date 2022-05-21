import UIKit
import CaBUIKit

// MARK: - Delegate

protocol CalendarPickerHeaderDelegate: AnyObject {

    func didTapHeaderView()
    
}

final class CalendarPickerHeaderView: UIView {

    // MARK: - Private Types

    private enum Constants {

        enum Fonts {

            static var titleFont: UIFont {
                return .init(name: "HelveticaNeue-Bold", size: 26.0)!
            }

            static var dayOfWeekFont: UIFont {
                return CaBFont.Comfortaa.bold(size: 12.0)
            }

        }

        enum Padding {

            static var monthLabel: CGFloat {
                return 16.0
            }

            static var dayOfWeekStackView: CGFloat {
                return 4.0
            }

        }

        static var separatorHeight: CGFloat {
            return 1.0
        }

        static var cornerRadius: CGFloat {
            return 8.0
        }

    }

    // MARK: - Internal Properties

    var colorScheme: CaBColorScheme = .default
    weak var delegate: CalendarPickerHeaderDelegate?

    var baseDate = Date() {
        didSet {
            monthLabel.text = dateFormatter.string(from: baseDate)
        }
    }

    // MARK: - Private Properties

    private lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constants.Fonts.titleFont
        label.text = "Month"
        label.accessibilityTraits = .header
        label.isAccessibilityElement = true
        return label
    }()

    private lazy var dayOfWeekStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        return stackView
    }()

    private lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .transparentGray20Alpha
        return view
    }()

    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale.autoupdatingCurrent
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMM y")
        return dateFormatter
    }()

    // MARK: - Init

    init(colorScheme: CaBColorScheme) {
        self.colorScheme = colorScheme
        super.init(frame: CGRect.zero)

        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Internal Methods

    override func layoutSubviews() {
        super.layoutSubviews()

        configureConstraints()
    }

    // MARK: - Private Methods

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false

        backgroundColor = .white

        layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner
        ]
        layer.cornerCurve = .continuous
        layer.cornerRadius = Constants.cornerRadius

        addSubview(monthLabel)
        addSubview(dayOfWeekStackView)
        addSubview(separatorView)

        for dayNumber in 1...7 {
            let dayLabel = UILabel()
            let attributedDay = NSAttributedString(string: dayOfWeekLetter(for: dayNumber),
                                                   attributes: [
                                                    .font: Constants.Fonts.dayOfWeekFont,
                                                    .foregroundColor: colorScheme.highlightPrimaryColor
                                                   ])
            dayLabel.attributedText = attributedDay
            dayLabel.textAlignment = .center
            dayOfWeekStackView.addArrangedSubview(dayLabel)
        }

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapHeaderView(_:)))
        addGestureRecognizer(gestureRecognizer)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            monthLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.Padding.monthLabel),
            monthLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Padding.monthLabel),
            monthLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Padding.monthLabel),

            dayOfWeekStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dayOfWeekStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dayOfWeekStackView.bottomAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: -Constants.Padding.dayOfWeekStackView),

            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: Constants.separatorHeight)
        ])
    }

    private func dayOfWeekLetter(for dayNumber: Int) -> String {
        switch dayNumber {
        case 1:
            return "S"
        case 2:
            return "M"
        case 3:
            return "T"
        case 4:
            return "W"
        case 5:
            return "T"
        case 6:
            return "F"
        case 7:
            return "S"
        default:
            return ""
        }
    }

    @objc
    private func didTapHeaderView(_ recognizer: UIGestureRecognizer) {
        delegate?.didTapHeaderView()
    }

}

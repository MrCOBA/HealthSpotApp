import UIKit
import CaBUIKit
import CaBFoundation

final class MedicineItemTableViewCell: UITableViewCell {

    // MARK: - Internal Types

    typealias CellModel = MedicineItemViewModel

    // MARK: - Private Types

    private enum Constants {

        enum Fonts {

            static var nameLabelFont: UIFont {
                return .init(name: "HelveticaNeue-Bold", size: 16.0)!
            }

            static var barcodeLabelFont: UIFont {
                return CaBFont.Comfortaa.regular(size: 12.0)
            }

            static var nextEventDateLabelFont: UIFont {
                return CaBFont.Comfortaa.bold(size: 14.0)
            }

        }

        static var cornerRadius: CGFloat {
            return 8.0
        }

        static var dateFormat: String {
            return "E, dd.MM.yy HH:mm Z"
        }

    }

    // MARK: - Internal Properties

    static var nib: UINib {
        return .init(nibName: cellIdentifier, bundle: .medicineChecker)
    }

    static var cellIdentifier: String {
        return "MedicineItemTableViewCell"
    }

    var colorScheme: CaBColorScheme = .default {
        didSet {
            configure(with: cellModel)
        }
    }

    var cellModel: CellModel = .empty {
        didSet {
            if oldValue != cellModel {
                configure(with: cellModel)
            }
        }
    }

    // MARK: - Private Properties

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var itemIconImageView: UIImageView!
    @IBOutlet private weak var imageLoadingIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var nextEventDateLabel: UILabel!
    @IBOutlet private weak var plainIconImageView: UIImageView!

    // MARK: - Internal Methods

    // MARK: Overrides

    override func awakeFromNib() {
        super.awakeFromNib()

        configure(with: cellModel)
    }

    // MARK: - Private Properties

    private func configure(with cellModel: CellModel) {
        containerView.layer.cornerRadius = Constants.cornerRadius
        containerView.backgroundColor = .white
        plainIconImageView.image = .MedicineChecker.plainIcon
        plainIconImageView.tintColor = colorScheme.attributesTertiaryColor

        configureIconImageView(with: cellModel)
        configureItemNameLabel(with: cellModel)
        configureNextEventDateLabel(with: cellModel)
    }

    private func configureIconImageView(with cellModel: MedicineItemViewModel) {
        itemIconImageView.layer.cornerRadius = Constants.cornerRadius

        imageLoadingIndicator.startAnimating()
        itemIconImageView.imageFromServerURL(cellModel.imageUrl, placeholder: cellModel.placeholderIcon) { [weak self] in
            self?.imageLoadingIndicator.stopAnimating()
        }
    }

    private func configureItemNameLabel(with cellModel: CellModel) {
        let attributedName = NSAttributedString(text: cellModel.name,
                                                textColor: colorScheme.highlightPrimaryColor,
                                                font: Constants.Fonts.nameLabelFont)
        nameLabel.attributedText = attributedName
    }

    private func configureNextEventDateLabel(with cellModel: CellModel) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.dateFormat
        let nextEventDates: [Date] = cellModel.periods.compactMap({
            guard let frequency = $0.frequency else {
                return nil
            }

            return Date().nextEventDate(startDate: $0.startDate, endDate: $0.endDate, frequency: frequency)
        })

        var closestDateString = "Next event: "
        if let closestDate = Date.closestDate(from: nextEventDates) {
            closestDateString += dateFormatter.string(from: closestDate)
        }
        else {
            closestDateString += "-"
        }

        let attributedNextEventDate = NSAttributedString(text: closestDateString,
                                                         textColor: colorScheme.highlightPrimaryColor,
                                                         font: Constants.Fonts.nextEventDateLabelFont)
        nextEventDateLabel.attributedText = attributedNextEventDate
    }

}

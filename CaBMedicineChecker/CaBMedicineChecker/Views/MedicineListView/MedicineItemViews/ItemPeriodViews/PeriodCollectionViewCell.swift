import UIKit
import CaBFoundation
import CaBUIKit

final class PeriodCollectionViewCell: UICollectionViewCell {

    // MARK: - Internal Types

    typealias CellModel = MedicineItemViewModel.Period

    // MARK: - Private Types

    private enum Constants {

        enum DateFormat {

            static var large: String {
                return "E, dd.MM.yy HH:mm Z"
            }

            static var small: String {
                return "dd.MM.yy HH:mm"
            }

        }

        enum Font {

            static var titleFont: UIFont {
                return CaBFont.Comfortaa.medium(size: 14.0)
            }

            static var dateFont: UIFont {
                return CaBFont.Comfortaa.light(size: 14.0)
            }

        }

        static var cornerRadius: CGFloat {
            return 8.0
        }

    }

    // MARK: - Internal Properties

    static var cellIdentifier: String {
        return "PeriodCollectionViewCell"
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

    private var dateFormatter: DateFormatter!

    @IBOutlet private weak var frequencyIconImageView: UIImageView!
    @IBOutlet private weak var frequencyTitleLabel: UILabel!
    @IBOutlet private weak var nextEventDateLabel: UILabel!
    @IBOutlet private weak var lastEventDateLabel: UILabel!

    // MARK: - Internal Methods

    // MARK: Overrides

    override func awakeFromNib() {
        super.awakeFromNib()

        dateFormatter = DateFormatter()
        configure(with: cellModel)
    }

    // MARK: - Private Methods

    private func configure(with cellModel: CellModel) {
        contentView.layer.cornerRadius = Constants.cornerRadius
        contentView.backgroundColor = .white

        configureFrequencyViews(with: cellModel)
        configureNextEventDateLabel(with: cellModel)
        configureLastEventDateLabel(with: cellModel)
    }

    private func configureFrequencyViews(with cellModel: CellModel) {
        frequencyIconImageView.image = cellModel.frequency?.icon ?? .MedicineChecker.noRepeat
        frequencyIconImageView.tintColor = colorScheme.attributesTertiaryColor

        let attributedTitle = NSAttributedString(string: cellModel.frequency?.title ?? "No Repeat",
                                                 attributes: [.foregroundColor: colorScheme.attributesTertiaryColor,
                                                              .font: Constants.Font.titleFont])
        frequencyTitleLabel.attributedText = attributedTitle
    }

    private func configureNextEventDateLabel(with cellModel: CellModel) {
        dateFormatter.dateFormat = Constants.DateFormat.large

        var nextEventDateString = (cellModel.startDate > Date()) ? dateFormatter.string(from: cellModel.startDate) : "-"
        if let frequency = cellModel.frequency {
            guard let nextEventDate = cellModel.startDate.nextEventDate(cellModel.endDate, frequency: frequency) else {
                nextEventDateString = "-"
                return
            }
            nextEventDateString = dateFormatter.string(from: nextEventDate)
        }

        let attributedString = NSAttributedString(string: nextEventDateString,
                                                  attributes: [.foregroundColor: colorScheme.highlightPrimaryColor,
                                                               .font: Constants.Font.dateFont])
        nextEventDateLabel.attributedText = attributedString
    }

    private func configureLastEventDateLabel(with cellModel: CellModel) {
        dateFormatter.dateFormat = Constants.DateFormat.small

        var endDateString = "-"
        if let endDate = cellModel.endDate {
            endDateString = dateFormatter.string(from: endDate)
        }

        let attributedString = NSAttributedString(string: endDateString,
                                                  attributes: [.foregroundColor: colorScheme.highlightPrimaryColor,
                                                               .font: Constants.Font.dateFont])
        lastEventDateLabel.attributedText = attributedString
    }

}

// MARK: - Helper

extension MedicineItemViewModel.Period.Frequency {

    fileprivate var title: String {
        switch self {
        case .daily:
            return "Daily"

        case .weekly:
            return "Weekly"

        case .monthly:
            return "Monthly"

        case .yearly:
            return "Yearly"
        }
    }

    fileprivate var icon: UIImage {
        switch self {
        case .daily:
            return .MedicineChecker.dailyIcon

        case .weekly:
            return .MedicineChecker.weeklyIcon

        case .monthly:
            return .MedicineChecker.monthlyIcon

        case .yearly:
            return .MedicineChecker.yearlyIcon
        }
    }

}

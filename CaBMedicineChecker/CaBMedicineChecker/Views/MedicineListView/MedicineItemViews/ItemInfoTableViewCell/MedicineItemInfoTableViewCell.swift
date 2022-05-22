import CaBFoundation
import CaBUIKit
import UIKit

final class MedicineItemInfoTableViewCell: UITableViewCell {

    // MARK: - Private Types

    private enum Constants {

        static var cornerRadius: CGFloat {
            return 8.0
        }

        enum Fonts {

            static var titleFont: UIFont {
                return CaBFont.Comfortaa.bold(size: 14.0)
            }

            static var sourceFont: UIFont {
                return CaBFont.Comfortaa.light(size: 12.0)
            }

        }

    }

    // MARK: - Internal Properties

    static var cellIdentifier: String {
        return "MedicineItemInfoTableViewCell"
    }

    static var nib: UINib {
        return .init(nibName: cellIdentifier, bundle: .medicineChecker)
    }

    var colorScheme: CaBColorScheme = .default

    // MARK: - Private Properties

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var sourceTitleLabel: UILabel!
    @IBOutlet private weak var sourceInfoLabel: UILabel!

    // MARK: - Internal Methods

    func configure(with title: String, source: String) {
        containerView.layer.cornerRadius = Constants.cornerRadius
        containerView.backgroundColor = .white

        configureTitleLabel(with: title)
        configureInfoLabel(with: source)
    }

    // MARK: - Private Methods

    private func configureTitleLabel(with title: String) {
        let attributedTitle = NSAttributedString(string: title,
                                                 attributes: [.foregroundColor: colorScheme.highlightPrimaryColor,
                                                              .font: Constants.Fonts.titleFont])
        sourceTitleLabel.attributedText = attributedTitle
    }

    private func configureInfoLabel(with source: String) {
        let attributedSource = NSAttributedString(string: source,
                                                  attributes: [.foregroundColor: colorScheme.highlightPrimaryColor,
                                                               .font: Constants.Fonts.sourceFont])
        sourceInfoLabel.attributedText = attributedSource
    }
    
}

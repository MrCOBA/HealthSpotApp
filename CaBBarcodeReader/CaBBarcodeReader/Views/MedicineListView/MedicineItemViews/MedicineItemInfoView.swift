import UIKit
import CaBUIKit
import CaBSDK

final class MedicineItemInfoView: UIViewController {

    // MARK: - Private Types

    private enum Constants {

        static var imageViewCornerRadius: CGFloat {
            return 8.0
        }

        enum Fonts {

            static var titleLabelFont: UIFont {
                return UIFont(name: "HelveticaNeue-Bold", size: 30.0)!
            }

            static var costLabelFont: UIFont {
                return CaBFont.Comfortaa.bold(size: 20.0)
            }


        }

    }

    // MARK: - Internal Properties

    var colorScheme: CaBColorScheme = .default {
        didSet {
            configure(with: viewModel)
        }
    }

    var viewModel: MedicineItemViewModel = .empty {
        didSet {
            if oldValue != viewModel {
                configure(with: viewModel)
            }
        }
    }

    // MARK: - Private Properties

    @IBOutlet private weak var imageLoadingIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var itemIconImageView: UIImageView!
    @IBOutlet private weak var itemTitleLabel: UILabel!
    @IBOutlet private weak var itemCostLabel: UILabel!

    @IBOutlet private weak var itemInfoDataTableView: UITableView!

    private var dataSource: [(title: String, source: String)] {
        get {
            var dataSource = [(title: String, source: String)]()

            dataSource += viewModel.barcode.isEmpty ? [] : [("Barcode:", viewModel.barcode)]
            dataSource += viewModel.producer.isEmpty ? [] : [("Producer:", viewModel.producer)]
            dataSource += viewModel.dosageForm.isEmpty ? [] : [("Dosage Form:", viewModel.dosageForm)]

            return dataSource
        }
    }

    // MARK: - Internal Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        itemInfoDataTableView.register(MedicineItemInfoTableViewCell.nib,
                                       forCellReuseIdentifier: MedicineItemInfoTableViewCell.cellIdentifier)

        configure(with: viewModel)
    }

    // MARK: - Private Methods

    private func configure(with viewModel: MedicineItemViewModel) {
        imageLoadingIndicator.tintColor = colorScheme.highlightPrimaryColor
        imageLoadingIndicator.stopAnimating()

        view.backgroundColor = colorScheme.backgroundPrimaryColor

        configureIconImageView(with: viewModel)
        configureTitleLabel(with: viewModel)
        configureCostLabel(with: viewModel)
    }

    private func configureIconImageView(with viewModel: MedicineItemViewModel) {
        itemIconImageView.layer.cornerRadius = Constants.imageViewCornerRadius

        imageLoadingIndicator.startAnimating()
        itemIconImageView.imageFromServerURL(viewModel.imageUrl, placeholder: .MedicineChecker.placeholderIcon) { [weak self] in
            self?.imageLoadingIndicator.stopAnimating()
        }
    }

    private func configureTitleLabel(with viewModel: MedicineItemViewModel) {
        let attributedTitle = NSAttributedString(string: viewModel.name,
                                                 attributes: [.foregroundColor: colorScheme.highlightPrimaryColor,
                                                              .font: Constants.Fonts.titleLabelFont])
        itemTitleLabel.attributedText = attributedTitle
    }

    private func configureCostLabel(with viewModel: MedicineItemViewModel) {
        let costString = "\(viewModel.cost) ₽"
        let attributedCostString = NSAttributedString(string: costString,
                                                      attributes: [.foregroundColor: colorScheme.attributesTertiaryColor,
                                                                   .font: Constants.Fonts.costLabelFont])
        itemCostLabel.attributedText = attributedCostString
    }

}

// MARK: - Protocol UITableViewDataSource

extension MedicineItemInfoView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MedicineItemInfoTableViewCell.cellIdentifier,
                                                       for: indexPath) as? MedicineItemInfoTableViewCell
        else {
            logError(message: "Unexpected cell type, fall to the default")
            return UITableViewCell()
        }

        let infoSource = dataSource[indexPath.row]

        cell.colorScheme = colorScheme
        cell.configure(with: infoSource.title, source: infoSource.source)
        
        return cell
    }

}

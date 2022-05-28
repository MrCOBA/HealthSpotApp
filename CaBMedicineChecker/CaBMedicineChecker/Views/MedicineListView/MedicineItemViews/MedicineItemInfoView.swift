import UIKit
import CaBUIKit
import CaBFoundation

protocol MedicineItemInfoViewEventsHandler: AnyObject {

    func didTapPeriodCell(with id: String)
    func didTapAddPeriodButton()
    func didFinish()
    
}

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

    weak var eventsHandler: MedicineItemInfoViewEventsHandler?

    var colorScheme: CaBColorScheme = .default {
        didSet {
            configure(with: viewModel)
        }
    }

    var viewModel: MedicineItemViewModel = .empty {
        didSet {
            if oldValue != viewModel && isViewLoaded {
                configure(with: viewModel)
            }
        }
    }

    // MARK: - Private Properties

    @IBOutlet private weak var imageLoadingIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var itemIconImageView: UIImageView!
    @IBOutlet private weak var itemTitleLabel: UILabel!
    @IBOutlet private weak var getMoreButton: CaBButton!

    @IBOutlet private weak var itemPeriodCollectionView: UICollectionView!
    @IBOutlet private weak var itemInfoDataTableView: UITableView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!

    private var dataSource: [(title: String, source: String)] {
        get {
            var dataSource = [(title: String, source: String)]()

            dataSource += viewModel.barcode.isEmpty ? [] : [("Barcode:", viewModel.barcode)]
            dataSource += viewModel.producer.isEmpty ? [] : [("Producer:", viewModel.producer)]
            dataSource += viewModel.activeComponent.isEmpty ? [] : [("Active component:", viewModel.activeComponent)]

            return dataSource
        }
    }

    // MARK: - Internal Methods

    // MARK: Overrides

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

        collectionViewHeightConstraint.constant = (viewModel.periods.count > 0) ? 100 : 0
        view.backgroundColor = colorScheme.backgroundPrimaryColor

        configureIconImageView(with: viewModel)
        configureTitleLabel(with: viewModel)
        configureGetMoreButton(with: viewModel)
        configureBackButton()
        configureRightButton()
    }

    private func configureBackButton() {
        let backBarButton = UIBarButtonItem(title: "Back",
                                            style: .plain,
                                            target: self,
                                            action: #selector(backButtonPressed))
        let attrs = [
            NSAttributedString.Key.font: CaBFont.Comfortaa.bold(size: 16),
            NSAttributedString.Key.foregroundColor: colorScheme.highlightPrimaryColor
        ]
        backBarButton.setTitleTextAttributes(attrs, for: .normal)
        navigationItem.leftBarButtonItem = backBarButton
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

    private func configureGetMoreButton(with viewModel: MedicineItemViewModel) {
        getMoreButton.setTitle("Get more...", for: .normal)
        getMoreButton.apply(configuration: CaBButtonConfiguration.Default.button(of: .secondary, with: colorScheme))
    }

    private func configureRightButton() {
        let rightBarButton = UIBarButtonItem(image: .MedicineChecker.dailyIcon,
                                             style: .plain,
                                             target: self,
                                             action: #selector(rightButtonPressed))
        let attrs = [
            NSAttributedString.Key.foregroundColor: colorScheme.highlightPrimaryColor
        ]
        rightBarButton.setTitleTextAttributes(attrs, for: .normal)
        navigationItem.rightBarButtonItem = rightBarButton
    }

    private func checkIfEventsHandlerSet() {
        guard eventsHandler != nil else {
            logError(message: "EventsHandler expected to be set")
            return
        }
    }

    @IBAction private func openLink(_ sender: Any) {
        if let url = viewModel.marketUrl, UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }

    @objc
    private func rightButtonPressed() {
        checkIfEventsHandlerSet()

        eventsHandler?.didTapAddPeriodButton()
    }

    @objc
    private func backButtonPressed() {
        checkIfEventsHandlerSet()

        eventsHandler?.didFinish()
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

// MARK: - Protocol UICollectionViewDelegate

extension MedicineItemInfoView: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        checkIfEventsHandlerSet()

        eventsHandler?.didTapPeriodCell(with: viewModel.periods[indexPath.item].id)
    }

}

// MARK: - Protocol UICollectionViewDataSource

extension MedicineItemInfoView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.periods.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PeriodCollectionViewCell.cellIdentifier,
                                                            for: indexPath) as? PeriodCollectionViewCell
        else {
            logError(message: "Unexpected cell type, fall to the default")
            return UICollectionViewCell()
        }

        cell.backgroundColor = .clear
        cell.colorScheme = colorScheme
        cell.cellModel = viewModel.periods[indexPath.row]

        return cell
    }

}

// MARK: - View Factory

extension MedicineItemInfoView {

    static func makeView() -> MedicineItemInfoView {
        return UIStoryboard.MedicineItemInfoView.instantiateMedicineItemInfoViewController()
    }

}

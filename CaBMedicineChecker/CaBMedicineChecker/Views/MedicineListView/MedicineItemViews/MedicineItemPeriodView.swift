import UIKit
import CaBUIKit
import CaBFoundation

final class MedicineItemPeriodView: UIViewController {

    // MARK: - Private Types
    
    enum Constants {
        
        static var headerCornerRadius: CGFloat {
            return 8.0
        }
        
    }
    
    // MARK: - Internal Types
    
    enum Section: CaseIterable {
        case startDate
        case endDate
    }
    
    // MARK: - Internal Properties

    var viewModel: MedicineItemViewModel.Period = .empty {
        didSet {
            if (oldValue != viewModel), isViewLoaded {
                configure()
            }
        }
    }

    var colorScheme: CaBColorScheme = .default

    weak var eventsHandler: MedicineItemPeriodViewEventsHandler?
    
    // MARK: - Private Properties
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, MedicineDatePickerItem>!
    private var snapshot: NSDiffableDataSourceSnapshot<Section, MedicineDatePickerItem>!
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d MMM yyyy, hh:mm a"
        return dateFormatter
    }()
    
    // MARK: Outlets
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var addPeriodButton: CaBButton!
    @IBOutlet private weak var deletePeriodButton: CaBButton!
    
    // MARK: - Internal Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeSections()
    }
    
    // MARK: - Private Methods
    
    private func configure() {
        view.backgroundColor = colorScheme.backgroundPrimaryColor
        
        configureAddPeriodButton()
        configureDeletePeriodButton()
        configureBackButton()
        
        updateSections()
    }
    
    private func initializeSections() {
        let headerCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, MedicineDatePickerItem> { [weak self] (cell, _, item) in
            guard let this = self else {
                return
            }
            
            if case let MedicineDatePickerItem.header(date) = item {
                var content = cell.defaultContentConfiguration()
                content.text = this.dateFormatter.string(from: date)
                cell.contentConfiguration = content
            }
            
            let headerDisclosureOption = UICellAccessory.OutlineDisclosureOptions(style: .header)
            cell.accessories = [.outlineDisclosure(options:headerDisclosureOption)]
            
            let view = UIView()
            view.backgroundColor = .white
            view.layer.cornerRadius = Constants.headerCornerRadius
            cell.backgroundView = view
            cell.tintColor = self?.colorScheme.highlightPrimaryColor
        }
        
        let pickerCellRegistration = UICollectionView.CellRegistration<ItemPeriodDatePickerCell, MedicineDatePickerItem> { (cell, _, item) in
            cell.item = item
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, MedicineDatePickerItem>(collectionView: collectionView) { (collectionView, indexPath, datePickerItem) -> UICollectionViewCell? in
            switch datePickerItem {
            case .header(_):
                let cell = collectionView.dequeueConfiguredReusableCell(using: headerCellRegistration,
                                                                        for: indexPath,
                                                                        item: datePickerItem)
                return cell
                
            case .picker(_, _):
                let cell = collectionView.dequeueConfiguredReusableCell(using: pickerCellRegistration,
                                                                        for: indexPath,
                                                                        item: datePickerItem)
                return cell
            }
        }
        
        var dataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, MedicineDatePickerItem>()
        dataSourceSnapshot.appendSections([.endDate, .startDate])
        dataSource.apply(dataSourceSnapshot)
        
        configure()
    }
    
    private func updateSections() {
        Section.allCases.forEach { update(section: $0, with: viewModel) }
    }
    
    private func update(section identifier: Section, with viewModel: MedicineItemViewModel.Period) {
        var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<MedicineDatePickerItem>()
        
        let date: Date
        switch identifier {
        case .startDate:
            date = viewModel.startDate
            
        case .endDate:
            date = viewModel.endDate ?? Date()
        }
        
        let header = MedicineDatePickerItem.header(date)
        sectionSnapshot.append([header])
        
        let action = UIAction(handler: { [unowned self] (action) in
            guard let picker = action.sender as? UIDatePicker else {
                return
            }
            
            reloadHeader(with: picker.date, identifier: identifier)
            
            checkIfEventsHandlerSet()
            eventsHandler?.didChangeDate(for: identifier.toDateIdentifier, to: picker.date)
        })
        
        let picker = MedicineDatePickerItem.picker(date, action)
        sectionSnapshot.append([picker], to: header)
        sectionSnapshot.expand([header])
        
        dataSource.apply(sectionSnapshot, to: identifier, animatingDifferences: false)
    }
    
    private func reloadHeader(with date: Date, identifier: Section) {
        let sectionSnapshot = dataSource.snapshot(for: identifier)
        
        guard let oldHeaderItem = sectionSnapshot.rootItems.first,
              let datePickerItem = sectionSnapshot.snapshot(of: oldHeaderItem).items.first
        else {
            return
        }
        
        let newHeaderItem = MedicineDatePickerItem.header(date)
        var newSectionSnapshot = sectionSnapshot

        newSectionSnapshot.insert([newHeaderItem], before: oldHeaderItem)
        newSectionSnapshot.delete([oldHeaderItem])
        newSectionSnapshot.append([datePickerItem], to: newHeaderItem)
        newSectionSnapshot.expand([newHeaderItem])
        
        dataSource.apply(newSectionSnapshot, to: identifier, animatingDifferences: false)
    }
    
    private func configureAddPeriodButton() {
        addPeriodButton.apply(configuration: CaBButtonConfiguration.Default.button(of: .tertiary, with: colorScheme))
        addPeriodButton.setTitle("Apply", for: .normal)
    }

    private func configureDeletePeriodButton() {
        deletePeriodButton.isHidden = (viewModel.actionType == .add)
        deletePeriodButton.apply(configuration: CaBButtonConfiguration.Service.noticeButton(with: colorScheme, icon: nil))
        deletePeriodButton.setTitle("Delete", for: .normal)
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

    private func checkIfEventsHandlerSet() {
        if eventsHandler == nil {
            logError(message: "Eventshandler expected to be set")
        }
    }

    // MARK: User Actions
    
    @objc
    private func backButtonPressed() {
        checkIfEventsHandlerSet()

        eventsHandler?.didFinishEditing()
    }

    @IBAction private func tapEditPeriodActionButton() {
        checkIfEventsHandlerSet()

        eventsHandler?.didTapPeriodActionButton(viewModel.actionType)
    }

    @IBAction private func tapDeletePeriodActionButton() {
        checkIfEventsHandlerSet()

        eventsHandler?.didTapPeriodActionButton(.delete(id: viewModel.id))
    }

}

// MARK: - Helpers

extension MedicineItemPeriodView.Section {
    
    var toDateIdentifier: ParameterDatePickerTableViewCell.ID {
        switch self {
        case .startDate:
            return .startDate
            
        case .endDate:
            return .endDate
        }
    }
}

// MARK: - View Factory

extension MedicineItemPeriodView {

    static func makeView() -> MedicineItemPeriodView {
        return UIStoryboard.MedicineItemPeriodView.instantiateMedicineItemPeriodViewController()
    }

}

import UIKit
import CaBUIKit
import CaBFoundation

// MARK: - EventsHandler

protocol MedicineItemPeriodViewEventsHandler: AnyObject {

    func didTapPeriodActionButton(_ action: MedicineItemPeriodActionType)
    func didChangeDate(for id: ParameterDatePickerTableViewCell.ID, to date: Date)
    func didSelectItem(_ item: MenuItem)
    func didEndEditingText(with text: String?)
    func didFinishEditing()

}

final class MedicineItemPeriodViewLegacy: UIViewController {

    // MARK: - Private Types

    private enum Constants {

        static var font: UIFont {
            return CaBFont.Comfortaa.medium(size: 17.0)
        }

    }
    
    private enum Section: Int, CaseIterable {
        case startDate
        case endDate
        case additional
    }

    // MARK: - Internal Properties

    var viewModel: MedicineItemViewModel.Period = .empty {
        didSet {
            if oldValue != viewModel {
                configure()
            }
        }
    }

    var colorScheme: CaBColorScheme = .default

    weak var eventsHandler: MedicineItemPeriodViewEventsHandler?

    // MARK: - Private Properties

    @IBOutlet private weak var periodEditorTableView: UITableView!
    @IBOutlet private weak var addPeriodButton: CaBButton!
    @IBOutlet private weak var deletePeriodButton: CaBButton!

    // MARK: - Internal Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }

    // MARK: - Private Methods
    
    private func makeCell(with indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        
        switch section {
        case .startDate:
            switch indexPath.row {
            case 0:
                return makeDatePickerCell(with: indexPath, id: .startDate)
                
            case 1:
                return makeMenuCell(with: indexPath, id: .repeatMenu)
                
            default:
                return UITableViewCell()
            }
            
        case .endDate:
            switch indexPath.row {
            case 0:
                return makeMenuCell(with: indexPath, id: .endDateMenu)
                
            case 1:
                return makeDatePickerCell(with: indexPath, id: .endDate)
                
            default:
                return UITableViewCell()
            }
            
        case .additional:
            return makeInputCell(with: indexPath)
        }
    }
    
    private func makeDatePickerCell(with indexPath: IndexPath, id: ParameterDatePickerTableViewCell.ID) -> UITableViewCell {
        guard let cell = periodEditorTableView.dequeueReusableCell(withIdentifier: ParameterDatePickerTableViewCell.cellIdentifier,
                                                                   for: indexPath) as? ParameterDatePickerTableViewCell
        else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        cell.configure(for: id, with: colorScheme)
        
        switch id {
        case .startDate:
            cell.setDate(viewModel.startDate)
            
        case .endDate:
            cell.setDate(viewModel.endDate ?? Date())
        }
        
        return cell
    }
        
    private func makeMenuCell(with indexPath: IndexPath, id: ParameterMenuTableViewCell.ID) -> UITableViewCell {
        guard let cell = periodEditorTableView.dequeueReusableCell(withIdentifier: ParameterMenuTableViewCell.cellIdentifier,
                                                                   for: indexPath) as? ParameterMenuTableViewCell
        else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        cell.configure(for: id, with: colorScheme)
        
        switch id {
        case .repeatMenu:
            cell.setItem(to: viewModel.toRepeatMenuAction)
            
        case .endDateMenu:
            cell.setItem(to: viewModel.toEndDateMenuAction)
        }
        
        return cell
    }
    
    private func makeInputCell(with indexPath: IndexPath) -> UITableViewCell {
        guard let cell = periodEditorTableView.dequeueReusableCell(withIdentifier: ParameterInputTableViewCell.cellIdentifier,
                                                                   for: indexPath) as? ParameterInputTableViewCell
        else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        cell.configure(with: viewModel.hint ?? "", colorScheme)
        
        return cell
    }

    private func configure() {
        view.backgroundColor = colorScheme.backgroundPrimaryColor

        configureTableView()
        configureBackButton()
        configureAddPeriodButton()
        configureDeletePeriodButton()
        
        periodEditorTableView.reloadData()
    }
    
    private func configureTableView() {
        periodEditorTableView.register(ParameterDatePickerTableViewCell.nib, forCellReuseIdentifier: ParameterDatePickerTableViewCell.cellIdentifier)
        periodEditorTableView.register(ParameterMenuTableViewCell.nib, forCellReuseIdentifier: ParameterMenuTableViewCell.cellIdentifier)
        periodEditorTableView.register(ParameterInputTableViewCell.nib, forCellReuseIdentifier: ParameterInputTableViewCell.cellIdentifier)
        periodEditorTableView.register(ParameterSectionHeaderTableViewCell.nib, forCellReuseIdentifier: ParameterSectionHeaderTableViewCell.cellIdentifier)
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

    private func configureAddPeriodButton() {
        addPeriodButton.apply(configuration: CaBButtonConfiguration.Default.button(of: .tertiary, with: colorScheme))
        addPeriodButton.setTitle("Apply", for: .normal)
    }

    private func configureDeletePeriodButton() {
        deletePeriodButton.isHidden = (viewModel.actionType == .add)
        deletePeriodButton.apply(configuration: CaBButtonConfiguration.Service.noticeButton(with: colorScheme, icon: nil))
        deletePeriodButton.setTitle("Delete", for: .normal)
    }

    private func checkIfEventsHandlerSet() {
        if eventsHandler == nil {
            logError(message: "Eventshandler expected to be set")
        }
    }

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

extension MedicineItemPeriodViewLegacy: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = periodEditorTableView.dequeueReusableCell(withIdentifier: ParameterSectionHeaderTableViewCell.cellIdentifier) as? ParameterSectionHeaderTableViewCell,
              let section = Section(rawValue: section)
        else {
            return UIView()
        }
        
        let title: String
        switch section {
        case .startDate:
            title = "Start Parameters"
            
        case .endDate:
            title = "End Parameters"
            
        case .additional:
            title = "Additional Parameters"
        }
        
        headerView.configure(with: title, colorScheme)
        headerView.backgroundColor = .clear
        
        return headerView
    }
    
}

extension MedicineItemPeriodViewLegacy: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else {
            return 0
        }
        
        switch section {
        case .startDate:
            return 2
            
        case .endDate:
            return (viewModel.endDate == nil) ? 1 : 2
            
        case .additional:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = makeCell(with: indexPath)
        cell.backgroundColor = .clear
        return cell
    }
    
}

extension MedicineItemPeriodViewLegacy: InputParameterPeriodViewDelegate {
    
    func didEndEditing(with text: String?) {
        checkIfEventsHandlerSet()
        
        eventsHandler?.didEndEditingText(with: text)
    }
    
}

extension MedicineItemPeriodViewLegacy: ItemPeriodMenuViewDelegate {
    
    func didSelectItem(_ item: MenuItem) {
        checkIfEventsHandlerSet()
        
        eventsHandler?.didSelectItem(item)
    }
    
}

extension MedicineItemPeriodViewLegacy: ItemPeriodDatePickerViewDelegate {
    
    func didChangeDate(for id: ParameterDatePickerTableViewCell.ID, to date: Date) {
        checkIfEventsHandlerSet()
        
        eventsHandler?.didChangeDate(for: id, to: date)
    }
    
}

// MARK: - Helper

extension MedicineItemViewModel.Period {

    fileprivate var toRepeatMenuAction: MenuItem {
        let action = MenuItem.repeatCases.first(where: { $0.rawValue == frequency?.rawValue }) ?? .noRepeat
        return action
    }

    fileprivate var toEndDateMenuAction: MenuItem {
        let action: MenuItem = (endDate == nil) ? .noEndDate : .concreteEndDate
        return action
    }

}

// MARK: - View Factory

extension MedicineItemPeriodViewLegacy {

    static func makeView() -> MedicineItemPeriodViewLegacy {
        return UIStoryboard.MedicineItemPeriodViewLegacy.instantiateMedicineItemPeriodViewController()
    }

}

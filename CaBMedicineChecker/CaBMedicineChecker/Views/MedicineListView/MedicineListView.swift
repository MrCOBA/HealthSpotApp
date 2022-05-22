import UIKit
import CaBUIKit
import CaBSDK

// MARK: - EventsHandler

protocol MedicineListViewEventsHandler: AnyObject {

    func didSelectRow(with id: String)
    func didTapScanButton()

}

final class MedicineListView: UIViewController {

    // MARK: - Internal Properties

    weak var eventsHandler: MedicineListViewEventsHandler?
    
    var colorScheme: CaBColorScheme = .default {
        didSet {
            configure()
        }
    }

    var cellModels: [MedicineItemViewModel] = [] {
        didSet {
            if oldValue != cellModels && isViewLoaded {
                updateTableView()
            }
        }
    }

    // MARK: - Private Properties

    @IBOutlet private weak var calendarPickerView: CalendarPickerView!
    @IBOutlet private weak var medicineItemsListTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        medicineItemsListTableView.layoutIfNeeded()
    }

    private func configure() {
        navigationItem.title = "Medicine Checker"
        medicineItemsListTableView.register(MedicineItemTableViewCell.nib,
                                            forCellReuseIdentifier: MedicineItemTableViewCell.cellIdentifier)
        configureRightButton()

        updateTableView()
    }

    private func configureRightButton() {
        let rightBarButton = UIBarButtonItem(image: .MedicineChecker.scanIcon,
                                             style: .plain,
                                             target: self,
                                             action: #selector(rightButtonPressed))
        let attrs = [
            NSAttributedString.Key.foregroundColor: colorScheme.highlightPrimaryColor
        ]
        rightBarButton.setTitleTextAttributes(attrs, for: .normal)
        navigationItem.rightBarButtonItem = rightBarButton
    }

    private func updateTableView() {
        medicineItemsListTableView.reloadData()
    }

    private func checkIfEventsHandlerSet() {
        guard eventsHandler != nil else {
            logError(message: "EventsHandler expected to be set")
            return
        }
    }

    @objc
    private func rightButtonPressed() {
        checkIfEventsHandlerSet()

        eventsHandler?.didTapScanButton()
    }

}

// MARK: - Protocol UITableViewDataSource

extension MedicineListView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MedicineItemTableViewCell.cellIdentifier,
                                                       for: indexPath) as? MedicineItemTableViewCell
        else {
            logError(message: "Unexpected cell type, fall to the default")
            return UITableViewCell()
        }

        cell.backgroundColor = .clear

        cell.colorScheme = colorScheme
        cell.cellModel = cellModels[indexPath.row]

        return cell
    }

}

// MARK: - Protocl UITableViewDelegate

extension MedicineListView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        checkIfEventsHandlerSet()

        eventsHandler?.didSelectRow(with: cellModels[indexPath.row].id)
    }

}

// MARK: - View Factory

extension MedicineListView {

    static func makeView() -> MedicineListView {
        return UIStoryboard.MedicineListView.instantiateMedicineListViewController()
    }

}

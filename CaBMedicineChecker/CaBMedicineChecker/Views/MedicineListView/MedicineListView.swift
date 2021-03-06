import UIKit
import CaBUIKit
import CaBFoundation

// MARK: - EventsHandler

protocol MedicineListViewEventsHandler: AnyObject {

    func didFilterBy(date: Date?)
    func didSelectRow(with id: String)
    func didRemoveRow(with id: String)
    func didUpdateContent()
    func didTapScanButton()

}

final class MedicineListView: UIViewController {

    // MARK: - Private Types

    private enum Constants {

        static var cornerRadius: CGFloat {
            return 8.0
        }

    }

    // MARK: - Internal Properties

    weak var eventsHandler: MedicineListViewEventsHandler?

    var colorScheme: CaBColorScheme = .default {
        didSet {
            configure()
        }
    }

    var dataSource: (source: [MedicineItemViewModel], isOfflineModeEnabled: Bool) = ([], false) {
        didSet {
            refreshControl.endRefreshing()
            if oldValue != dataSource && isViewLoaded {
                configure()
            }
        }
    }

    // MARK: - Private Properties

    @IBOutlet private weak var calendarPickerView: CalendarView!
    @IBOutlet private weak var medicineItemsListTableView: UITableView!
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        calendarPickerView.delegate = self
        medicineItemsListTableView.register(MedicineItemTableViewCell.nib,
                                            forCellReuseIdentifier: MedicineItemTableViewCell.cellIdentifier)

        configure()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        medicineItemsListTableView.layoutIfNeeded()
    }

    private func configure() {
        navigationItem.title = "Medicine Checker"
        calendarPickerView.layer.cornerRadius = Constants.cornerRadius
        configureRightButton()
        configureRefreshControl()
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
        navigationItem.rightBarButtonItem = dataSource.isOfflineModeEnabled ? nil : rightBarButton
    }

    private func configureRefreshControl() {
        refreshControl.addTarget(self, action: #selector(contentUpdateInitialized), for: .valueChanged)
        medicineItemsListTableView.refreshControl = refreshControl
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

    @objc func contentUpdateInitialized() {
        checkIfEventsHandlerSet()

        eventsHandler?.didUpdateContent()
    }

}

// MARK: - Protocol UITableViewDataSource

extension MedicineListView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.source.count
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
        cell.cellModel = dataSource.source[indexPath.row]

        return cell
    }

}

// MARK: - Protocl UITableViewDelegate

extension MedicineListView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        checkIfEventsHandlerSet()

        eventsHandler?.didSelectRow(with: dataSource.source[indexPath.row].id)
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: nil) { [weak self] (action, view, completionHandler) in
            guard let this = self else {
                return
            }

            this.eventsHandler?.didRemoveRow(with: this.dataSource.source[indexPath.row].id)
            completionHandler(true)
        }

        action.backgroundColor = colorScheme.backgroundPrimaryColor
        action.image = .MedicineChecker.removeIcon

        return .init(actions: [action])
    }

}

// MARK: - Protocol CalendarViewDelegate

extension MedicineListView: CalendarViewDelegate {

    func selectedDateChanged(to date: Date) {
        checkIfEventsHandlerSet()

        eventsHandler?.didFilterBy(date: date)
    }

}

// MARK: - View Factory

extension MedicineListView {

    static func makeView() -> MedicineListView {
        return UIStoryboard.MedicineListView.instantiateMedicineListViewController()
    }

}

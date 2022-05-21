import UIKit
import CaBUIKit
import CaBSDK

// MARK: - EventsHandler

protocol MedicineListViewEventsHandler: AnyObject {

    func didSelectRow(with id: Int16)
    func didFinish()

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
            if oldValue != cellModels {
                configure()
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

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if isMovingFromParent {
            checkIfEventsHandlerSet()

            eventsHandler?.didFinish()
        }
    }

    private func configure() {
        medicineItemsListTableView.register(MedicineItemTableViewCell.nib,
                                            forCellReuseIdentifier: MedicineItemTableViewCell.cellIdentifier)
    }

    private func checkIfEventsHandlerSet() {
        guard eventsHandler != nil else {
            logError(message: "EventsHandler expected to be set")
            return
        }
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

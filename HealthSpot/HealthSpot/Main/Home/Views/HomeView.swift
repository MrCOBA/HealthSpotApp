import UIKit
import CaBUIKit
import CaBFoundation

// MARK: - Cell Identifier

fileprivate enum HomeCellIdentifier: CaseIterable {

    case healthActivity

}
extension HomeCellIdentifier: RawRepresentable {

    typealias RawValue = IndexPath

    var rawValue: IndexPath {
        switch self {
        case .healthActivity:
            return .init(row: 0, section: 0)
        }
    }

    init?(rawValue: IndexPath) {
        switch rawValue {
        case .init(row: 0, section: 0):
            self = .healthActivity

        default:
            return nil
        }
    }

}

// MARK: - View Datasource

struct HomeViewDataSource: Equatable {

    var activityContext: HealthActivityTableViewCell.Context

    static var empty: Self {
        return .init(activityContext: .empty)
    }
    
}

final class HomeView: UITableViewController {

    // MARK: - Internal Properties

    var dataSource: HomeViewDataSource = .empty {
        didSet {
            if oldValue != dataSource {
                configure()
            }
        }
    }

    var colorScheme: CaBColorScheme = .default {
        didSet {
            configure()
        }
    }

    // MARK: - Internal Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(HealthActivityTableViewCell.nib, forCellReuseIdentifier: HealthActivityTableViewCell.cellIdentifier)
        configure()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HomeCellIdentifier.allCases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let identifier = HomeCellIdentifier(rawValue: indexPath) else {
            logError(message: "Unexpected cell identifier, fall to the default")
            return UITableViewCell()
        }

        switch identifier {
        case .healthActivity:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HealthActivityTableViewCell.cellIdentifier,
                                                           for: indexPath) as? HealthActivityTableViewCell
            else {
                logError(message: "Unexpected cell type, fall to the default")
                return UITableViewCell()
            }

            cell.colorScheme = colorScheme
            cell.context = dataSource.activityContext
            cell.backgroundColor = .clear
            
            return cell
        }
    }

    // MARK: - Private Methods

    private func configure() {
        view.backgroundColor = colorScheme.backgroundPrimaryColor
        navigationItem.title = "Health Spot Center"
        tableView.reloadData()
    }

}

// MARK: - View Factory

extension HomeView {

    static func makeView() -> HomeView {
        return UIStoryboard.HomeView.instantiateHomeViewController()
    }

}

import UIKit
import CaBUIKit

protocol HomeViewDelegate: AnyObject {

    func didTapCellActionButton(forCellWith id: Int)

}

final class HomeView: UIViewController {

    weak var delegate: HomeViewDelegate?
    var viewModelFactory: HomeScreenCellViewModelFactory?

    var colorScheme: CaBColorScheme = .default {
        didSet {
            homeTableView.reloadData()
        }
    }

    @IBOutlet private weak var homeTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModelFactory = HomeScreenCellViewModelFactoryImpl(eventsHandler: self)

        registerCells()
        applyColorScheme()
    }

    private func applyColorScheme() {
        view.backgroundColor = colorScheme.backgroundPrimaryColor
    }

    private func registerCells() {
        homeTableView.register(HomeScreenCell.nib, forCellReuseIdentifier: HomeScreenCell.cellIdentifier)
    }

    private func cellModel(for indexPath: IndexPath) -> HomeScreenCellViewModel {
        guard let viewModelFactory = viewModelFactory else {
            // TODO: Add log
            return .empty
        }

        return viewModelFactory.makeModel(for: indexPath) ?? .empty
    }

}

extension HomeView: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        guard let viewModelFactory = viewModelFactory else {
            // TODO: Add log
            return 0
        }

        return viewModelFactory.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModelFactory = viewModelFactory else {
            // TODO: Add log
            return 0
        }

        guard let section = HomeScreenCellViewModelFactoryImpl.Section(rawValue: section) else {
            // TODO: Add log
            return 0
        }

        return viewModelFactory.cellsCount(for: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeScreenCell.cellIdentifier,
                                                       for: indexPath) as? HomeScreenCell else {
            // TODO: Add log
            return UITableViewCell()
        }

        cell.backgroundColor = .clear
        cell.backgroundView = .init()
        cell.selectedBackgroundView = .init()

        cell.viewModel = cellModel(for: indexPath)
        
        return cell
    }

}

extension HomeView: HomeScreenCellEventsHandler {

    func actionButtonTap(forCellWith id: Int) {
        delegate?.didTapCellActionButton(forCellWith: id)
    }

}
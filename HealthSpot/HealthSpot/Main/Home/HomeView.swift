import UIKit

final class HomeView: UIViewController {

    @IBOutlet private weak var homeTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        registerCells()
    }

    private func registerCells() {
        homeTableView.register(HomeScreenCell.nib, forCellReuseIdentifier: HomeScreenCell.cellIdentifier)
    }

    private func cellModel(for indexPath: IndexPath) -> MainScreenCellViewModel {
        // TODO: Add model generation depends on IndexPath
        return .init(id: 0,
                     title: "Pocket Medicine Checker",
                     subtitle: "Помощник по приёму медикаментов",
                     description: "Здесь отображаются все ближайшие периоды прёма медикаментов",
                     actionButtonState: .shown(title: "Открыть приложение"),
                     eventsHandler: self)
    }

}

extension HomeView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeScreenCell.cellIdentifier,
                                                       for: indexPath) as? HomeScreenCell else {
            // TODO: Add log
            return UITableViewCell()
        }

        cell.viewModel = cellModel(for: indexPath)
        
        return cell
    }

}

extension HomeView: MainScreenCellEventsHandler {

    func actionButtonTap(forCellWith id: Int) {
        // TODO: Move to delegate
    }

}

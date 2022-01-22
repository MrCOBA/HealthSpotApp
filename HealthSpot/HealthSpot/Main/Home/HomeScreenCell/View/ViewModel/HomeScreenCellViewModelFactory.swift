import Foundation

// MARK: - Protocol

protocol HomeScreenCellViewModelFactory: AnyObject {

    var sections: [HomeScreenCellViewModelFactoryImpl.Section] { get }

    func cellsCount(for section: HomeScreenCellViewModelFactoryImpl.Section) -> Int
    func makeModel(for indexPath: IndexPath) -> HomeScreenCellViewModel?
}

// MARK: - Implementation

final class HomeScreenCellViewModelFactoryImpl: HomeScreenCellViewModelFactory {

    // MARK: - Internal Types

    enum Section: Int, CaseIterable {
        case main
    }

    enum Row: Int {
        case ActivityCell
        case PocketMedicineCheckerCell
        case WeeklyHomeChief
    }

    // MARK: - Private Types

    private enum Constant {

        enum CellCount {

            static var mainSection: Int {
                return 3
            }

        }

    }

    // MARK: - Internal Properties

    var sections: [Section] {
        return Section.allCases
    }

    // MARK: - Private Properties

    private weak var eventsHandler: HomeScreenCellEventsHandler?

    // MARK: - Init & Deinit

    init(eventsHandler: HomeScreenCellEventsHandler?) {
        self.eventsHandler = eventsHandler
    }

    // MARK: - Internal Methods

    func cellsCount(for section: Section) -> Int {
        switch section {
            case .main:
                return Constant.CellCount.mainSection
        }
    }

    func makeModel(for indexPath: IndexPath) -> HomeScreenCellViewModel? {
        let viewModel: HomeScreenCellViewModel

        guard let homeScreenCellPath = indexPath.toHomeScreenCellPath else {
            // TODO: Add log
            return nil
        }

        // TODO: Add localizations

        switch homeScreenCellPath.section {
            case .main:
                switch homeScreenCellPath.row {
                    case .ActivityCell:
                        viewModel = .init(id: homeScreenCellPath.row.rawValue,
                                          title: "Activity Statistics",
                                          description: "Helps to control your daily activity",
                                          actionButtonState: .shown(title: "More"),
                                          eventsHandler: eventsHandler)
                    case .PocketMedicineCheckerCell:
                        viewModel = .init(id: homeScreenCellPath.row.rawValue,
                                          title: "Pocket Medicine Checker",
                                          subtitle: "App cell",
                                          actionHint: "To get more...",
                                          actionButtonState: .shown(title: "Open app"),
                                          eventsHandler: eventsHandler)
                    case .WeeklyHomeChief:
                        viewModel = .init(id: homeScreenCellPath.row.rawValue,
                                          title: "Weekly Home Chief",
                                          subtitle: "App cell",
                                          actionHint: "To get more...",
                                          actionButtonState: .shown(title: "Open app"),
                                          eventsHandler: eventsHandler)
                }
        }

        return viewModel
    }

}

// MARK: - Helper

extension IndexPath {

    fileprivate typealias Factory = HomeScreenCellViewModelFactoryImpl

    fileprivate var toHomeScreenCellPath: (section: Factory.Section, row: Factory.Row)? {
        guard let section = Factory.Section(rawValue: self.section) else {
            return nil
        }

        guard let row = Factory.Row(rawValue: self.row) else {
            return nil
        }

        return (section, row)
    }

}

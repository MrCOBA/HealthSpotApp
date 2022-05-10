import UIKit
import CaBUIKit
import CaBRiblets
import CaBSDK

protocol MainViewEventsHandler: AnyObject {

    func didSelectTab(with child: MainView.Item)

}

final class MainView: CaBTabBarController {

    // MARK: - Internal Properties

    var dataSource = [Item]() {
        didSet {
            configureTabBarController()
        }
    }

    weak var eventsHandler: MainViewEventsHandler?

    // MARK: - Internal Methods

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        itemDelegate = self
        
        dataSource = Item.allCases
        configureTabBarController()
    }

    // MARK: - Private Methods

    private func configureTabBarController() {
        let items: [(Item, UITabBarItem)] = dataSource.map {
            let tabBarItem = UITabBarItem(title: tabBarItemTitle($0),
                                          image: .tabBarItemIcon($0, isSelectedState: false),
                                          selectedImage: .tabBarItemIcon($0, isSelectedState: true))
            return ($0, tabBarItem)
        }

        setContainers(with: items)
    }

}

extension MainView: CaBTabBarControllerDelegate {

    func didSelectItem(_ item: CaBTabBarController.Item) {
        guard let eventsHandler = eventsHandler else {
            logError(message: "EventsHandler expected to be set")
            return
        }

        eventsHandler.didSelectTab(with: item)
    }

}

// MARK: - TabBar Items

extension MainView.Item {

    fileprivate static var allCases: [CaBTabBarController.Item] {
        return [.home, .medicineController, .foodController, .settings]
    }

    static var home: Self {
        return .init(rawValue: "home")
    }

    static var medicineController: Self {
        return .init(rawValue: "medicineController")
    }

    static var foodController: Self {
        return .init(rawValue: "foodController")
    }

    static var settings: Self {
        return .init(rawValue: "settings")
    }

}

// MARK: - Helpers

extension MainView {

    fileprivate func tabBarItemTitle(_ item: MainView.Item) -> String? {
        switch item {
        case .home:
            return "Center"

        case .medicineController:
            return "Medicine"

        case .foodController:
            return "Food"

        case .settings:
            return "Settings"

        default:
            logError(message: "Unknown item with identifier: <\(item.rawValue)>")
            return nil
        }
    }

}

extension UIImage {

    fileprivate static func tabBarItemIcon(_ item: MainView.Item, isSelectedState: Bool) -> UIImage? {
        switch item {
        case .home:
            return .Main.homeIcon(isSelectedState)

        case .medicineController:
            return .Main.medicineIcon(isSelectedState)

        case .foodController:
            return .Main.foodIcon(isSelectedState)

        case .settings:
            return .Main.settingsIcon(isSelectedState)

        default:
            logError(message: "Unknown item with identifier: <\(item.rawValue)>")
            return nil
        }
    }

}


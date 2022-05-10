import UIKit
import CaBSDK

public protocol CaBTabBarControllerDelegate: AnyObject {

    func didSelectItem(_ item: CaBTabBarController.Item)

}

open class CaBTabBarController: UITabBarController {

    // MARK: - Public Types

    public struct Item: RawRepresentable, Equatable, Hashable, Comparable {

        // MARK: - Public Types

        public typealias RawValue = String

        // MARK: - Public Properties

        public var rawValue: RawValue

        // MARK: Protocol Hashable

        public var hashValue: Int {
            return rawValue.hashValue
        }

        public init(rawValue: RawValue) {
            self.rawValue = rawValue
        }

        // MARK: Protocol Comparable

        public static func <(lhs: Item, rhs: Item) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }

    }

    public typealias ItemContainer = (item: Item, container: BaseContainerViewController)

    // MARK: - Public Properties

    public var colorScheme: CaBColorScheme = .default {
        didSet {
            configureTabBar()
        }
    }

    public weak var itemDelegate: CaBTabBarControllerDelegate?

    // MARK: - Private Properties

    private var itemContainers = [ItemContainer]() {
        didSet {
            let viewControllers = itemContainers.map { $0.container }
            setViewControllers(viewControllers, animated: true)
        }
    }

    // MARK: - Open Methods

    open override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self

        configureTabBar()
    }

    open func setContainers(with items: [(item: Item, tabBarItem: UITabBarItem)]) {
        itemContainers = items.map {
            let container = BaseContainerViewController()
            container.tabBarItem = $0.tabBarItem

            return ItemContainer(item: $0.item, container: container)
        }
    }

    open func setController(_ controller: UIViewController, to item: Item) {
        guard let container = itemContainers.first(where: { $0.item == item } ) else {
            logError(message: "Container with item: <\(item.rawValue)> not attached")
            return
        }

        container.container.addChild(controller)
    }

    // MARK: - Public Methods

    public func containerIndex(_ item: Item) -> Int {
        guard let container = itemContainers.enumerated().first(where: { $0.element.item == item } ) else {
            logError(message: "Container with item: <\(item.rawValue)> not attached")
            return -1
        }

        return container.offset
    }

    // MARK: - Private Methods

    private func configureTabBar() {
        let appearance = makeAppearance(with: colorScheme)

        tabBar.standardAppearance = appearance
    }

    private func makeAppearance(with colorScheme: CaBColorScheme) -> UITabBarAppearance {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.backgroundImage = UIImage(color: .transparentGray20Alpha)

        let itemAppearance = makeItemAppearance(with: colorScheme)
        appearance.stackedLayoutAppearance = itemAppearance
        appearance.inlineLayoutAppearance = itemAppearance
        appearance.compactInlineLayoutAppearance = itemAppearance

        return appearance
    }

    private func makeItemAppearance(with colorScheme: CaBColorScheme) -> UITabBarItemAppearance {
        var attrs = [
            NSAttributedString.Key.foregroundColor: colorScheme.attributesTertiaryColor,
            NSAttributedString.Key.font: CaBFont.Comfortaa.medium(size: 10)
        ]

        let itemAppearance = UITabBarItemAppearance()
        itemAppearance.normal.iconColor = colorScheme.attributesTertiaryColor
        itemAppearance.normal.titleTextAttributes = attrs

        attrs = [
            NSAttributedString.Key.foregroundColor: colorScheme.highlightPrimaryColor,
            NSAttributedString.Key.font: CaBFont.Comfortaa.medium(size: 10)
        ]
        
        itemAppearance.selected.iconColor = colorScheme.highlightPrimaryColor
        itemAppearance.selected.titleTextAttributes = attrs

        return itemAppearance
    }
    
}

// MARK: - Protocol UITabBarControllerDelegate

extension CaBTabBarController: UITabBarControllerDelegate {

    public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let selectedCotainer = itemContainers.first(where: { $0.container === viewController }) else {
            logError(message: "Unexpected container was selected")
            return
        }

        itemDelegate?.didSelectItem(selectedCotainer.item)
    }

}

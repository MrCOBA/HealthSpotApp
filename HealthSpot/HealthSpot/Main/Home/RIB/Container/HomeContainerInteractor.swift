import CaBRiblets
import CaBFoundation

// MARK: - Listener

protocol HomeContainerListener: AnyObject {

}

final class HomeContainerInteractor: BaseInteractor {

    // MARK: - Internal Properties

    weak var router: HomeContainerRouter?

    // MARK: - Private Properties

    private weak var listener: HomeContainerListener?

    // MARK: - Init

    init(listener: HomeContainerListener?) {
        self.listener = listener

        super.init()
    }

    // MARK: - Private Methods

    private func checkIfRouterSet() {
        guard router != nil else {
            logError(message: "Router expected to be set")
            return
        }
    }

}

import CaBRiblets
import CaBFoundation

// MARK: - Listener

public protocol MedicineCheckerContainerListener: AnyObject {

}

public final class MedicineCheckerContainerInteractor: BaseInteractor {

    // MARK: - Internal Properties

    weak var router: MedicineCheckerContainerRouter?

    // MARK: - Private Properties

    private weak var listener: MedicineCheckerContainerListener?

    // MARK: - Init

    public init(listener: MedicineCheckerContainerListener?) {
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

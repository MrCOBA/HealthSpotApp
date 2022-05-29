import CaBRiblets
import CaBUIKit
import CaBFoundation
import CaBFirebaseKit
import UIKit

// MARK: - Protocol

public protocol MedicineCheckerContainerRouter: ViewableRouter {

    func attachMedicineListRouter()
    func attachAlert(with error: Error)

}

// MARK: - Implementation

final class MedicineCheckerContainerRouterImpl: BaseRouter, MedicineCheckerContainerRouter {

    // MARK: - Internal Properties

    var view: UIViewController {
        return containerViewController
    }

    // MARK: - Private Properties

    private var containerViewController: CaBNavigationController
    private let rootServices: MedicineCheckerRootServices
    private let interactor: MedicineCheckerContainerInteractor

    private let alertFactory: MedicineCheckerAlertFactory

    private var rootChild: ViewableRouter?

    // MARK: - Init

    init(rootServices: MedicineCheckerRootServices, view: CaBNavigationController, interactor: MedicineCheckerContainerInteractor) {
        self.rootServices = rootServices
        self.containerViewController = view
        self.interactor = interactor

        self.alertFactory = MedicineCheckerAlertFactory()

        super.init(interactor: interactor)
    }

    // MARK: - Internal Methods

    override func start() {
        super.start()

        attachMedicineListRouter()
    }

    func attachMedicineListRouter() {
        let router = MedicineListBuilder(factory: rootServices, listener: interactor).build()

        attachChildWithEmbed(router)
    }

    func attachAlert(with error: Error) {
        guard let error = error as? FirebaseFirestoreMedicineCheckerError else {
            logWarning(message: "Unknown error was obtained: <\(error.localizedDescription)>")
            return
        }

        if case .noItemFound = error, case .itemAlreadyExists = error {
            logInfo(message: "Handled by <BarcodeCaptureInteractor>")
            return
        }

        let alert = alertFactory.makeAlert(of: error)
        view.present(alert, animated: true)
    }

    // MARK: - Private Methods

    private func attachChildWithEmbed(_ child: ViewableRouter) {
        if rootChild != nil {
            rootChild?.stop()
        }

        rootChild = child
        rootChild?.start()
        containerViewController.embedIn(child.view, animated: true)
    }

}

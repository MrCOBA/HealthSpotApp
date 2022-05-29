import CaBRiblets

final class BarcodeCaptureBuilder: Builder {

    private weak var listener: BarcodeCaptureListener?
    private let factory: MedicineCheckerRootServices

    init(factory: MedicineCheckerRootServices, listener: BarcodeCaptureListener?) {
        self.factory = factory
        self.listener = listener
    }

    func build() -> ViewableRouter {
        let view = BarcodeCaptureView.makeView()

        let interactor = BarcodeCaptureInteractor(coreDataAssistant: factory.coreDataAssistant,
                                                  firebaseFirestoreMedicineCheckerController: factory.firebaseFirestoreMedicineCheckerController,
                                                  listener: listener)

        view.eventsHandler = interactor
        let router = BarcodeCaptureRouterImpl(view: view, interactor: interactor)
        interactor.router = router

        return router
    }

}

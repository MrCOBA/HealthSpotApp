
public final class WaitingBuilder: Builder {

    public init() {
        /* Do Nothing */
    }

    public func build() -> ViewableRouter {
        let view = WaitingView.makeView()

        let interactor = WaitingInteractor()

        let presenter = WaitingPresenterImpl(view: view, interactor: interactor)
        interactor.presenter = presenter

        let router = WaitingRouter(view: view, interactor: interactor)

        return router
    }

}

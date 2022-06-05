
final class WaitingInteractor: BaseInteractor {

    var presenter: WaitingPresenter?

    override func start() {
        super.start()

        presenter?.updateView()
    }
    
}

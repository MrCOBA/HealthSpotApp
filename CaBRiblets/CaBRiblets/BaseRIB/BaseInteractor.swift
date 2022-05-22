import CaBFoundation

// MARK: - Protocol

public protocol Interactor: AnyObject {

    func start()
    func stop()
    
}

// MARK: - Implementation

open class BaseInteractor: Interactor {

    // MARK: - Private Properties

    private var isStarted: Bool = false

    // MARK: - Init

    public init() {
        /* Do Nothing */
    }

    // MARK: - Public Methods

    // MARK: Protocol Interactor

    open func start() {
        guard !isStarted else {
            logWarning(message: "Interactor has already started")
            return
        }

        isStarted = true
    }

    open func stop() {
        guard isStarted else {
            logWarning(message: "Interactor has already started")
            return
        }

        isStarted = false
    }

}

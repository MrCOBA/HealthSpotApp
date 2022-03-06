
// MARK: - Protocol

public protocol Interactor: AnyObject {

    func start()
    func stop()
    
}

// MARK: - Implementation

public class BaseInteractor: Interactor {

    // MARK: - Private Properties

    private var isStarted: Bool = false

    // MARK: - Init

    public init() {
        /* Do Nothing */
    }

    // MARK: - Public Methods

    // MARK: Protocol Interactor

    public func start() {
        guard !isStarted else {
            // TODO: Add Logs
            return
        }

        isStarted = true
    }

    public func stop() {
        guard isStarted else {
            // TODO: Add Logs
            return
        }

        isStarted = false
    }

}

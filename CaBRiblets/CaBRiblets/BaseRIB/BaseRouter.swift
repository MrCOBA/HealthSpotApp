import UIKit
import CaBFoundation

// MARK: - Protocol

public protocol Router: AnyObject {

    func start()
    func stop()

}

public protocol ViewableRouter: Router {

    var view: UIViewController { get }

}

// MARK: - Implementation

open class BaseRouter: Router {

    // MARK: - Public Properties

    public private(set) var children: [Router] = []

    // MARK: - Private Properties

    private let interactor: Interactor

    private(set) public var isStarted: Bool = false

    // MARK: - Init

    public init(interactor: Interactor) {
        self.interactor = interactor
    }

    // MARK: - Public Methods

    public func attachChild(_ child: Router) {
        guard !children.contains(where: { $0 === child }) else {
            logWarning(message: "This child has already attached")
            return
        }

        children.append(child)
        child.start()
    }

    public func detachChild(_ child: Router) {
        guard let index = children.firstIndex(where: { $0 === child }) else {
            logWarning(message: "This child has already detached")
            return
        }

        child.stop()
        children.remove(at: index)
    }

    public func detachAll() {
        let childrenToDetach = children
        childrenToDetach.forEach {
            detachChild($0)
        }
    }

    // MARK: Protocol Router

    open func start() {
        guard !isStarted else {
            logWarning(message: "Router has already started")
            return
        }

        interactor.start()

        isStarted = true
    }

    open func stop() {
        guard isStarted else {
            logWarning(message: "Router has already stopped")
            return
        }

        interactor.stop()

        isStarted = false
    }

}

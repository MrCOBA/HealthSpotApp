import Foundation

public protocol Observable {

    associatedtype Observer

    var observers: ObserversCollection<Observer> { get }

    func addObserver(_ observer: Observer)
    func removeObserver(_ observer: Observer)
}

extension Observable {

    public func addObserver(_ observer: Observer) {
        observers.add(observer)
    }

    public func removeObserver(_ observer: Observer) {
        observers.remove(observer)
    }

}

public final class ObserversCollection<Observer> {

    // MARK: - Private properties

    private let observers = NSHashTable<AnyObject>.weakObjects()
    private let lock = NSRecursiveLock()

    // MARK: - Init

    public init() { /* Do Nothing */ }

    // MARK: - Public Methods

    public func isAdded(_ observer: Observer) -> Bool {
        return lock.withCritical {
            let observerAsObject = observer as AnyObject
            return observers.contains(observerAsObject)
        }
    }

    public func add(_ observer: Observer) {
        lock.withCritical {
            guard !isAdded(observer) else {
                NSLog("<WARNING>: Attempt to add observer (\(observer)) which had been added already")
                return
            }

            let observer = observer as AnyObject
            observers.add(observer)
        }
    }

    public func add(from collection: ObserversCollection<Observer>) {
        let otherObservers = collection.getAllObservers()
        for observer in otherObservers {
            add(observer)
        }
    }

    public func remove(_ observer: Observer) {
        lock.withCritical {
            guard isAdded(observer) else {
                NSLog("<WARNING>: Attempt to remove observer (\(observer)) which hasn't been added yet")
                return
            }

            let observer = observer as AnyObject
            observers.remove(observer)
        }
    }

    public func removeAll() {
        lock.withCritical {
            observers.removeAllObjects()
        }
    }

    public func move(to collection: ObserversCollection<Observer>) {
        lock.withCritical {
            collection.add(from: self)
            removeAll()
        }
    }

    public func notify(with closure: (Observer) -> ()) {
        for observer in getAllObservers() {
            closure(observer)
        }
    }

    // MARK: - Private Methods

    private func getAllObservers() -> [Observer] {
        return lock.withCritical { Array(observers.allObjects as! [Observer]) }
    }

}


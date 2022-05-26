public protocol ObservablePropertyOnChangeHandlerProvider: AnyObject {

    typealias ObservablePropertyOnChangeWrapper<Observer, Value> = (_ this: Self, _ observer: Observer, _ oldValue: Value, _ newValue: Value) -> Void
    typealias ObservablePropertyOnChangeHandler<Value> = (_ oldValue: Value, _ newValue: Value) -> Void

    func notify<Observer, Value>(_ observers: ObserversCollection<Observer>,
                                 wrapper: @escaping ObservablePropertyOnChangeWrapper<Observer, Value>) -> ObservablePropertyOnChangeHandler<Value>

}

extension ObservablePropertyOnChangeHandlerProvider {

    public func notify<Observer, Value>(_ observers: ObserversCollection<Observer>,
                                        wrapper: @escaping ObservablePropertyOnChangeWrapper<Observer, Value>) -> ObservablePropertyOnChangeHandler<Value> {

        return { [weak self] (oldValue: Value, newValue: Value) in
            guard let this = self else {
                return
            }

            observers.notify { observer in
                wrapper(this, observer, oldValue, newValue)
            }
        }
    }

}

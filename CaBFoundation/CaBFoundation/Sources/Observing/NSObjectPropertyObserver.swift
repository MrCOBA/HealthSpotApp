import Foundation

public final class NSObjectPropertyObserver<PropertyType>: NSObject {

    // MARK: - Public Types

    public typealias OnChangeHandler = (PropertyType?, PropertyType?) -> Void

    // MARK: - Private Properties

    private let object: NSObject
    private let keyPath: String
    private let onChange: OnChangeHandler

    // MARK: - Init & Deinit

    public init(object: NSObject,
                forKeyPath keyPath: String,
                onChange: @escaping OnChangeHandler) {

        self.object = object
        self.keyPath = keyPath
        self.onChange = onChange

        super.init()

        object.addObserver(self, forKeyPath: keyPath, options: [.old, .new], context: nil)
    }

    deinit {
        object.removeObserver(self, forKeyPath: keyPath)
    }

    public override func observeValue(forKeyPath keyPath: String?,
                                      of observingObject: Any?,
                                      change: [NSKeyValueChangeKey: Any]?,
                                      context: UnsafeMutableRawPointer?) {
        guard
            let valueChange = change,
            let object = observingObject as? NSObject,
            object === self.object,
            keyPath == self.keyPath
        else {
            super.observeValue(forKeyPath: keyPath, of: observingObject, change: change, context: context)
            return
        }

        let oldValue = valueChange[NSKeyValueChangeKey.oldKey] as? PropertyType
        let newValue = valueChange[NSKeyValueChangeKey.newKey] as? PropertyType

        onChange(oldValue, newValue)
    }

}

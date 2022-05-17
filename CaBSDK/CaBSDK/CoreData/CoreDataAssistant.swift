import CoreData

// MARK: - Protocol

public protocol CoreDataAssistant: AnyObject {

    func loadData(_ entityName: String, predicate: NSPredicate?, sortDescriptor: [NSSortDescriptor]?) -> NSMutableArray?
    func loadData<T: NSManagedObject>(_ entity: T.Type, predicate: NSPredicate? , sortDescriptor: [NSSortDescriptor]?) -> NSMutableArray?

    func removeData(_ entityName: String, predicate: NSPredicate?, sortDescriptor: [NSSortDescriptor]?)
    func removeData<T: NSManagedObject>(_ entity: T.Type, predicate: NSPredicate? , sortDescriptor: [NSSortDescriptor]?)

    func createEntity(_ entityName: String) -> NSManagedObject?
    func createEntity<T: NSManagedObject>(_ entity: T.Type) -> T?

    func saveData()

}

// MARK: - Impplementation

public final class CoreDataAssistantImpl: CoreDataAssistant {

    // MARK: - Private Properties

    private var context: NSManagedObjectContext?

    // MARK: - Init

    public init(context: NSManagedObjectContext?) {
        self.context = context
    }

    // MARK: - Public Methods

    public func entityDescription(_ entityName: String) -> NSEntityDescription? {
        guard let context = context else {
            logError(message: "Context expected to be set")
            return nil
        }

        return NSEntityDescription.entity(forEntityName: entityName, in: context)
    }

    public func loadData(_ entityName: String,
                         predicate: NSPredicate? = nil,
                         sortDescriptor: [NSSortDescriptor]? = nil) -> NSMutableArray? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)

        if predicate != nil {
            fetchRequest.predicate = predicate!
        }

        if sortDescriptor != nil {
            fetchRequest.sortDescriptors = sortDescriptor!
        }

        fetchRequest.returnsObjectsAsFaults = false

        guard let context = context else {
            logError(message: "Context expected to be set")
            return nil
        }

        do {
            let fetchResult = try context.fetch(fetchRequest)
            if fetchResult.count > 0 {
                return NSMutableArray.init(array: fetchResult)
            } else {
                return nil
            }
        } catch {
            logError(message: "Failed to fetch data with error <\(error.localizedDescription)>")
            return nil
        }
    }

    public func loadData<T: NSManagedObject>(_ entity: T.Type,
                                             predicate: NSPredicate? = nil,
                                             sortDescriptor: [NSSortDescriptor]? = nil) -> NSMutableArray? {
        return loadData(NSStringFromClass(T.self), predicate: predicate, sortDescriptor: sortDescriptor)
    }

    public func removeData(_ entityName: String,
                           predicate: NSPredicate? = nil,
                           sortDescriptor: [NSSortDescriptor]? = nil) {
        guard let fetchedResults = loadData(entityName, predicate: predicate, sortDescriptor: sortDescriptor) else {
            logInfo(message: "Fetched objects array is empty")
            return
        }

        guard let context = context else {
            logError(message: "Context expected to be set")
            return
        }

        for result in fetchedResults {
            guard let object = result as? NSManagedObject else {
                logWarning(message: "Unexpected fetch result type")
                continue
            }

            context.delete(object)
        }
    }

    public func removeData<T: NSManagedObject>(_ entity: T.Type,
                                               predicate: NSPredicate? = nil,
                                               sortDescriptor: [NSSortDescriptor]? = nil) {
        removeData(NSStringFromClass(T.self), predicate: predicate, sortDescriptor: sortDescriptor)
    }

    public func createEntity(_ entityName: String) -> NSManagedObject? {
        guard let context = context else {
            logError(message: "Context expected to be set")
            return nil
        }

        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
    }

    public func createEntity<T: NSManagedObject>(_ entity: T.Type) -> T? {
        return createEntity(NSStringFromClass(T.self)) as? T
    }

    public func saveData() {
        guard let context = context else {
            logError(message: "Context expected to be set")
            return
        }

        do {
            try context.save()
        }
        catch {
            logError(message: "Failed to save data with error <\(error.localizedDescription)>")
        }
    }

}

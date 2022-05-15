import CoreData
import CaBSDK

// MARK: - Protocol

public protocol CoreDataAssistant: AnyObject {

    func loadData<T: NSManagedObject>(_ entity: T.Type, predicate: NSPredicate? , sortDescriptor: [NSSortDescriptor]?) -> NSMutableArray?
    func removeData<T: NSManagedObject>(_ entity: T.Type, predicate: NSPredicate? , sortDescriptor: [NSSortDescriptor]?)
    func createEntity<T: NSManagedObject>(_ entity: T.Type) -> T?
    func saveData()

}

// MARK: - Impplementation

final class CoreDataAssistantImpl: CoreDataAssistant {

    // MARK: - Private Properties

    private var context: NSManagedObjectContext?

    // MARK: - Init

    init(context: NSManagedObjectContext?) {
        self.context = context
    }

    // MARK: - Internal Methods

    func loadData<T: NSManagedObject>(_ entity: T.Type,
                                      predicate: NSPredicate? = nil,
                                      sortDescriptor: [NSSortDescriptor]? = nil) -> NSMutableArray? {
        let fetchRequest = NSFetchRequest<T>(entityName: NSStringFromClass(T.self))

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

    func removeData<T: NSManagedObject>(_ entity: T.Type,
                                        predicate: NSPredicate? = nil,
                                        sortDescriptor: [NSSortDescriptor]? = nil) {
        guard let fetchedResults = loadData(entity, predicate: predicate, sortDescriptor: sortDescriptor) else {
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

    func createEntity<T: NSManagedObject>(_ entity: T.Type) -> T? {
        guard let context = context else {
            logError(message: "Context expected to be set")
            return nil
        }

        return entity.init(context: context)
    }

    func saveData() {
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

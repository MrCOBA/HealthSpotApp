import FirebaseFirestore
import CaBFoundation
import CoreData

// MARK: - Error

public enum FirebaseFirestoreMedicineCheckerError: Error {
    case noItemFound
    case itemAlreadyExists
    case failedToAddMedicineItemPeriod
    case failedToDeleteMedicineItemPeriod
    case failedToUpdateMedicineItemPeriod
    case failedToAddMedicineItem
    case failedToDeleteMedicineItem
    case failedToUpdateData
}

// MARK: - Protocols

public protocol FirebaseFirestoreMedicineCheckerDelegate: AnyObject {

    func didFinishStorageUpdate(with error: Error?)
    func didFinishUpload(with error: Error?)

}

public protocol FirebaseFirestoreMedicineCheckerController: AnyObject {

    var observers: ObserversCollection<FirebaseFirestoreMedicineCheckerDelegate> { get }

    func updateData(for userId: String)
    func addMedicineItem(with barcode: String, to userId: String)
    func deleteMedicineItem(with itemId: String, fromUser userId: String)
    func addMedicineItemPeriod(data: [String: Any], toItem itemId: String, ofUser userId: String)
    func updateMedicineItemPeriod(data: [String: Any], of periodId: String, inItem itemId: String, ofUser userId: String)
    func deleteMedicineItemPeriod(with periodId: String, fromItem itemId: String, ofUser userId: String)

    func add(observer: FirebaseFirestoreMedicineCheckerDelegate)
    func remove(observer: FirebaseFirestoreMedicineCheckerDelegate)

}

// MARK: - Implementation

final class FirebaseFirestoreMedicineCheckerControllerImpl: FirebaseFirestoreMedicineCheckerController, Observable {

    // MARK: - Private Types

    private typealias Error = FirebaseFirestoreMedicineCheckerError

    // MARK: - Internal Properties

    let observers = ObserversCollection<FirebaseFirestoreMedicineCheckerDelegate>()

    // MARK: - Private Properties

    private let coreDataAssistant: CoreDataAssistant
    private let dataBase: Firestore

    private var medicineItems = [QueryDocumentSnapshot]()
    private var medicineItemPeriods = [String: [QueryDocumentSnapshot]]()

    init(coreDataAssistant: CoreDataAssistant) {
        dataBase = Firestore.firestore()
        self.coreDataAssistant = coreDataAssistant
    }

    // MARK: - Internal Methods

    @MainActor
    func addMedicineItem(with barcode: String, to userId: String) {
        Task.init {
            do {
                let snapshot = try await dataBase.collection("sharedMedicineItems").whereField("qrcode", arrayContainsAny: [barcode, Int(barcode) ?? -1]).getDocuments()
                let medicineItemsReference = dataBase.collection("users").document(userId).collection("medicaments")
                await uploadMedicineItem(snapshot.documents.first, barcode: barcode, collectionReference: medicineItemsReference)
            }
            catch {
                logWarning(message: "Error obtained: <\(error.localizedDescription)>")
                observers.notify { $0.didFinishUpload(with: Error.failedToAddMedicineItem) }
            }
        }
    }

    func deleteMedicineItem(with itemId: String, fromUser userId: String) {
        let medicineItemsReference = dataBase.collection("users").document(userId).collection("medicaments")
        medicineItemsReference.document(itemId).delete() { [weak self] error in
            if let error = error {
                logWarning(message: "Error obtained: <\(error.localizedDescription)>")
                self?.observers.notify { $0.didFinishUpload(with: Error.failedToDeleteMedicineItem) }
                return
            }
            self?.observers.notify { $0.didFinishUpload(with: nil) }
        }
    }

    func addMedicineItemPeriod(data: [String: Any], toItem itemId: String, ofUser userId: String) {
        let medicineItemPeriodsReference = getPeriodsCollectionReference(from: itemId, userId)
        medicineItemPeriodsReference.addDocument(data: data) { [weak self] error in
            if let error = error {
                logWarning(message: "Error obtained: <\(error.localizedDescription)>")
                self?.observers.notify { $0.didFinishUpload(with: Error.failedToAddMedicineItemPeriod) }
                return
            }
            self?.observers.notify { $0.didFinishUpload(with: nil) }
        }
    }

    func updateMedicineItemPeriod(data: [String: Any], of periodId: String, inItem itemId: String, ofUser userId: String) {
        let medicineItemPeriodsReference = getPeriodsCollectionReference(from: itemId, userId)
        medicineItemPeriodsReference.document(periodId).updateData(data) { [weak self] error in
            if let error = error {
                logWarning(message: "Error obtained: <\(error.localizedDescription)>")
                self?.observers.notify { $0.didFinishUpload(with: Error.failedToUpdateMedicineItemPeriod) }
                return
            }
            self?.observers.notify { $0.didFinishUpload(with: nil) }
        }
    }

    func deleteMedicineItemPeriod(with periodId: String, fromItem itemId: String, ofUser userId: String) {
        let medicineItemPeriodsReference = getPeriodsCollectionReference(from: itemId, userId)
        medicineItemPeriodsReference.document(periodId).delete() { [weak self] error in
            if let error = error {
                logWarning(message: "Error obtained: <\(error.localizedDescription)>")
                self?.observers.notify { $0.didFinishUpload(with: Error.failedToDeleteMedicineItemPeriod) }
                return
            }
            self?.observers.notify { $0.didFinishUpload(with: nil) }
        }
    }

    @MainActor
    func updateData(for userId: String) {
        Task.init {
            do {
                let user = dataBase.collection("users").document(userId)
                medicineItems = try await getMedicineItems(from: user)
                medicineItemPeriods = try await getMedicineItemPeriods(from: medicineItems)
                await updateStorage()
            }
            catch {
                logWarning(message: "Error obtained: <\(error.localizedDescription)>")
                observers.notify { $0.didFinishStorageUpdate(with: Error.failedToUpdateData) }
            }
        }
    }

    func add(observer: FirebaseFirestoreMedicineCheckerDelegate) {
        observers.add(observer)
    }

    func remove(observer: FirebaseFirestoreMedicineCheckerDelegate) {
        observers.remove(observer)
    }

    // MARK: - Private Methods

    private func getPeriodsCollectionReference(from itemId: String, _ userId: String) -> CollectionReference {
        return dataBase.collection("users").document(userId).collection("medicaments").document(itemId).collection("periods")
    }

    private func getMedicineItems(from user: DocumentReference) async throws -> [QueryDocumentSnapshot] {
        let medicineItemsSnapshot = try await user.collection("medicaments").getDocuments()
        return medicineItemsSnapshot.documents
    }

    private func getMedicineItemPeriods(from medicineItems: [QueryDocumentSnapshot]) async throws -> [String: [QueryDocumentSnapshot]] {
        var medicineItemPeriodsSnapshots = [String: [QueryDocumentSnapshot]]()

        for item in medicineItems {
            let medicineItemPeriodsReference = item.reference.collection("periods")

            let medicineItemPeriodsSnapshot = try await medicineItemPeriodsReference.getDocuments()
            medicineItemPeriodsSnapshots[item.documentID] = medicineItemPeriodsSnapshot.documents
        }

        return medicineItemPeriodsSnapshots
    }

    private func updateStorage() async {
        let itemEntities: [NSManagedObject] = medicineItems.compactMap { item in
            guard let itemEntity = coreDataAssistant.createEntity("MedicineItem") else {
                return nil
            }

            let itemEntityWrapper = MedicineItemEntityWrapper(entityObject: itemEntity, coreDataAssistant: coreDataAssistant)
            itemEntityWrapper.id = item.documentID
            itemEntityWrapper.name = item["name"] as? String ?? ""
            itemEntityWrapper.producer = item["producer"] as? String ?? ""
            itemEntityWrapper.activeComponent = item["activeComponent"] as? String ?? ""
            itemEntityWrapper.barcode = item["barcode"] as? String ?? ""
            itemEntityWrapper.marketUrlString = item["marketUrl"] as? String ?? ""


            if let periods = medicineItemPeriods[item.documentID] {
                let periodEntities: [NSManagedObject] = periods.compactMap { period in
                    guard let periodEntity = coreDataAssistant.createEntity("MedicineItemPeriod") else {
                        return nil
                    }

                    let periodEntityWrapper = MedicineItemPeriodEntityWrapper(entityObject: periodEntity, coreDataAssistant: coreDataAssistant)
                    periodEntityWrapper.id = period.documentID

                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "E, dd.MM.yy HH:mm Z"
                    periodEntityWrapper.startDate = dateFormatter.date(from: period["startDate"] as? String ?? "") ?? Date()
                    periodEntityWrapper.endDate = dateFormatter.date(from: period["endDate"] as? String ?? "")
                    periodEntityWrapper.notificationHint = period["notificationHint"] as? String ?? ""
                    periodEntityWrapper.frequency = period["frequency"] as? String ?? ""

                    return periodEntity
                }

                itemEntityWrapper.periods = NSMutableArray(array: periodEntities)
            }

            return itemEntity
        }

        let user = UserEntityWrapper(coreDataAssistant: coreDataAssistant)
        user?.medicineItems = NSMutableArray(array: itemEntities)

        coreDataAssistant.saveData()

        observers.notify { $0.didFinishStorageUpdate(with: nil) }
    }

    private func uploadMedicineItem(_ item: QueryDocumentSnapshot?, barcode: String, collectionReference: CollectionReference) async {
        guard let item = item else {
            observers.notify { $0.didFinishStorageUpdate(with: Error.noItemFound) }
            return
        }
        var data = [String: Any]()

        data["name"] = item["name"] as? String ?? ""
        data["producer"] = item["producer"] as? String ?? ""
        data["activeComponent"] = item["active_component"] as? String ?? ""
        data["barcode"] = barcode
        data["marketUrl"] = item["url"] as? String ?? ""

        collectionReference.addDocument(data: data) { [weak self] error in
            if let error = error {
                logWarning(message: "Error obtained: <\(error.localizedDescription)>")
                self?.observers.notify { $0.didFinishUpload(with: Error.failedToAddMedicineItem) }
                return
            }

            self?.observers.notify { $0.didFinishUpload(with: nil) }
        }

    }

}


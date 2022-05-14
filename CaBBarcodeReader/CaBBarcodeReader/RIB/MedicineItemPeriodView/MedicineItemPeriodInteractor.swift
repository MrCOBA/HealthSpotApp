import CaBRiblets

protocol MedicineItemPeriodInteractor: Interactor {

    func updateStorage(_ field: MedicineItemPeriodInteractorImpl.UpdateField, with data: Any?)
    func addNewPeriod()

}

final class MedicineItemPeriodInteractorImpl: BaseInteractor, MedicineItemPeriodInteractor {

    enum UpdateField {
        case startDate
        case endDate
        case repeatType
        case notificationHint
    }

    func updateStorage(_ field: MedicineItemPeriodInteractorImpl.UpdateField, with data: Any?) {

    }

    func addNewPeriod() {

    }
    
}

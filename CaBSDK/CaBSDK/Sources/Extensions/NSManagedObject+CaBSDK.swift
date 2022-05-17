import CoreData

extension NSManagedObject {

    public enum EntityName {

        public static var user: String {
            return "User"
        }

        public static var medicineItem: String {
            return "MedicineItem"
        }

        public static var medicineItemPeriod: String {
            return "MedicineItemPeriod"
        }
        
    }

}

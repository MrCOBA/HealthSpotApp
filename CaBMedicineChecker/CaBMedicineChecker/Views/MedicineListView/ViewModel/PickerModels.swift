import UIKit

enum MedicineDatePickerItem: Hashable {
    case header(Date)
    case picker(Date, UIAction)
}

enum MedicinePickerItem: Hashable {
    case header(String)
    case picker(String, UIAction)
}

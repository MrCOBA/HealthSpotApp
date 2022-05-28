import UIKit
import CaBFoundation

struct MedicineItemViewModel: Equatable {

    struct Period: Equatable {

        typealias Frequency = Date.Frequency

        let id: String
        let startDate: Date
        let endDate: Date?
        let frequency: Frequency?
        let hint: String?
        let actionType: MedicineItemPeriodActionType

        static var empty: Self {
            return .init(id: "",
                         startDate: Date(),
                         endDate: nil,
                         frequency: nil,
                         hint: "",
                         actionType: .add)
        }
        
    }

    let id: String
    let barcode: String
    let marketUrl: URL?

    let name: String
    let imageUrl: URL?
    let producer: String
    let activeComponent: String
    let periods: [Period]

    static var empty: Self {
        return .init(id: "",
                     barcode: "",
                     marketUrl: nil,
                     name: "",
                     imageUrl: nil,
                     producer: "",
                     activeComponent: "",
                     periods: [])
    }

}

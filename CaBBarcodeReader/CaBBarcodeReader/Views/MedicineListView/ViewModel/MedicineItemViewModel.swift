import UIKit

struct MedicineItemViewModel: Equatable {

    struct Period: Equatable {

        enum Repeat {
            case daily
            case weekly
            case monthly
            case yearly
        }

        let startDate: Date
        let endDate: Date?
        let `repeat`: Repeat?
        let hint: String?

    }

    let id: Int16
    let barcode: String
    let marketUrl: URL?

    let name: String
    let imageUrl: URL?
    let producer: String
    let activeComponent: String
    let periods: [Period]

    static var empty: Self {
        return .init(id: -1,
                     barcode: "",
                     marketUrl: nil,
                     name: "",
                     imageUrl: nil,
                     producer: "",
                     activeComponent: "",
                     periods: [])
    }

}

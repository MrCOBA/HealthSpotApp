import UIKit
import CaBSDK

struct MedicineItemViewModel: Equatable {

    struct Period: Equatable {

        typealias Frequency = Date.Frequency

        let startDate: Date
        let endDate: Date?
        let frequency: Frequency?
        let hint: String?

        static var empty: Self {
            return .init(startDate: Date(),
                         endDate: nil,
                         frequency: nil,
                         hint: "")
        }
        
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
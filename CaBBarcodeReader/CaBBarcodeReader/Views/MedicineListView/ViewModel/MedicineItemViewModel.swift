import UIKit

struct MedicineItemViewModel: Equatable {
    let barcode: String
    let marketUrl: URL?

    let name: String
    let imageUrl: URL?
    let producer: String
    let activeSubstance: String
    let isRecipeNeeded: Bool
    let dosageForm: String
    let cost: UInt

    static var empty: Self {
        return .init(barcode: "",
                     marketUrl: nil,
                     name: "",
                     image: nil,
                     producer: "",
                     activeSubstance: "",
                     isRecipeNeeded: false,
                     dosageForm: "",
                     cost: 0)
    }

}

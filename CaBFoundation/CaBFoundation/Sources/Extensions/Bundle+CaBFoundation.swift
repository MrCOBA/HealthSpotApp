import UIKit

public extension Bundle {

    // MARK: Apps

    static var healthSpotApp: Bundle {
        return .init(identifier: "com.crunch.bugs.club.HealthSpot")!
    }

    // MARK: Frameworks
    
    static var uikit: Bundle {
        return .init(identifier: "com.crunch.bugs.club.CaBUIKit")!
    }

    static var medicineChecker: Bundle {
        return .init(identifier: "com.crunch.bugs.club.CaBMedicineChecker")!
    }

    static var authorization: Bundle {
        return .init(identifier: "com.crunch.bugs.club.CaBAuthorization")!
    }

    static var riblets: Bundle {
        return .init(identifier: "com.crunch.bugs.club.CaBRiblets")!
    }

}

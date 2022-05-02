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

    static var barcodeReader: Bundle {
        return .init(identifier: "com.crunch.bugs.club.CaBBarcodeReader")!
    }

    static var authorization: Bundle {
        return .init(identifier: "com.crunch.bugs.club.CaBAuthorization")!
    }

}

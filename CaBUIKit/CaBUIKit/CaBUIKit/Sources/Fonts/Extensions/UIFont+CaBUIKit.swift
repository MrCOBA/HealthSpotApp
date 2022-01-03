import UIKit

public extension UIFont {

    private static func registerFont(withFilenameString filenameString: String, bundle: Bundle) {

        guard let pathForResourceString = bundle.path(forResource: filenameString, ofType: nil) else {
            print("UIFont+:  Failed to register font - path for resource not found.")
            return
        }

        guard let fontData = NSData(contentsOfFile: pathForResourceString) else {
            print("UIFont+:  Failed to register font - font data could not be loaded.")
            return
        }

        guard let dataProvider = CGDataProvider(data: fontData) else {
            print("UIFont+:  Failed to register font - data provider could not be loaded.")
            return
        }

        guard let font = CGFont(dataProvider) else {
            print("UIFont+:  Failed to register font - font could not be loaded.")
            return
        }

        var errorRef: Unmanaged<CFError>? = nil
        if (CTFontManagerRegisterGraphicsFont(font, &errorRef) == false) {
            print("UIFont+:  Failed to register font - register graphics font failed - this font may have already been registered in the main bundle.")
        }
        
    }

    static func loadFonts() {
        UIFont.registerFont(withFilenameString: "Comfortaa-Bold.ttf", bundle: .uikit)
        UIFont.registerFont(withFilenameString: "Comfortaa-Light.ttf", bundle: .uikit)
        UIFont.registerFont(withFilenameString: "Comfortaa-Medium.ttf", bundle: .uikit)
        UIFont.registerFont(withFilenameString: "Comfortaa-Regular.ttf", bundle: .uikit)
        UIFont.registerFont(withFilenameString: "Comfortaa-SemiBold.ttf", bundle: .uikit)
        UIFont.registerFont(withFilenameString: "DotGothic16-Regular.ttf", bundle: .uikit)
        UIFont.registerFont(withFilenameString: "BadScript-Regular.ttf", bundle: .uikit)
    }
    
}

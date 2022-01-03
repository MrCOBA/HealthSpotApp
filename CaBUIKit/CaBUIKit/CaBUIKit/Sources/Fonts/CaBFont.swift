import UIKit

public struct CaBFont {

    public enum Comfortaa {

        public static func light(size: CGFloat) -> UIFont {
            guard let customFont = UIFont(name: "Comfortaa-Light", size: size) else {
                fatalError("Failed to load font.")
            }

            return customFont
        }

        public static func regular(size: CGFloat) -> UIFont {
            guard let customFont = UIFont(name: "Comfortaa-Regular", size: size) else {
                fatalError("Failed to load font.")
            }

            return customFont
        }

        public static func medium(size: CGFloat) -> UIFont {
            guard let customFont = UIFont(name: "Comfortaa-Medium", size: size) else {
                fatalError("Failed to load font.")
            }

            return customFont
        }

        public static func semiBold(size: CGFloat) -> UIFont {
            guard let customFont = UIFont(name: "Comfortaa-SemiBold", size: size) else {
                fatalError("Failed to load font.")
            }

            return customFont
        }

        public static func bold(size: CGFloat) -> UIFont {
            guard let customFont = UIFont(name: "Comfortaa-Bold", size: size) else {
                fatalError("Failed to load font.")
            }

            return customFont
        }

    }

    public enum BadScript {

        public static func regular(size: CGFloat) -> UIFont {
            guard let customFont = UIFont(name: "BadScript-Regular", size: size) else {
                fatalError("Failed to load font.")
            }

            return customFont
        }

    }

    public enum DotGothic {

        public static func regular(size: CGFloat) -> UIFont {
            guard let customFont = UIFont(name: "DotGothic16-Regular", size: size) else {
                fatalError("Failed to load font.")
            }

            return customFont
        }

    }

}

import UIKit

open class CaBTabBarItem: UITabBarItem {

    public let identifier: String

    public init(title: String?, image: UIImage?, selectedImage: UIImage?, identifier: String) {
        self.identifier = identifier

        super.init(title: title, image: image, selectedImage: selectedImage)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

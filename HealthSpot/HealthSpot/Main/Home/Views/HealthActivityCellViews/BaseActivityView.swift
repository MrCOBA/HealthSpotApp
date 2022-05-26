import UIKit
import CaBUIKit

class BaseActivityView: XibView {

    // MARK: - Internal Types

    enum Constants {

        enum Fonts {

            static var generalLabelFont: UIFont {
                return CaBFont.Comfortaa.bold(size: 27.0)
            }

            static var stateLabelFont: UIFont {
                return CaBFont.Comfortaa.bold(size: 15.0)
            }

        }

    }

    // MARK: - Internal Properties

    override var nibName: String {
        return String(describing: BaseActivityView.self)
    }

    // MARK: - Internal Properties

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var generalInfoLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!

}

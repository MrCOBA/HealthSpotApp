import Foundation
import UIKit

public final class CaBSwitchConfiguration: CaBUIConfiguration {

    // MARK: - Public Types

    public enum Default {

        public static func general(with colorScheme: CaBColorScheme) -> CaBSwitchConfiguration {
            return CaBSwitchConfiguration(backgroundColor: .transparentGray50Alpha,
                                          tintColor: colorScheme.textColor,
                                          externalColors: [colorScheme.attributesColor])
        }

    }

    // MARK: - Init & Deinit
    
    private init(backgroundColor: UIColor = .clear,
                 tintColor: UIColor? = nil,
                 externalColors: [UIColor] = []) {
        super.init(backgroundColor: backgroundColor,
                   tintColor: tintColor,
                   externalColors: externalColors)
    }

}

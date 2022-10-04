import UIKit
import SwiftUI

extension UIColor {

    // MARK: - Properties
    
    var swiftUIColor: Color {
        Color(self)
    }

    // MARK: - Inits

    convenience init(lightColor: UIColor, darkColor: UIColor, unspecifiedColor: UIColor = .black) {
        self.init { collection in
            switch collection.userInterfaceStyle {
            case .light:
                return lightColor
            case .dark:
                return darkColor
            case .unspecified:
                return unspecifiedColor
            @unknown default:
                assertionFailure("Programmer error: Unknown interface type.")
                return unspecifiedColor
            }
        }
    }

    convenience init(redInt: Int, greenInt: Int, blueInt: Int, alpha: Double = 1.0) {
        self.init(
            red: Double(redInt)/Double(255),
            green: Double(greenInt)/Double(255),
            blue: Double(blueInt)/Double(255),
            alpha: alpha
        )
    }
}

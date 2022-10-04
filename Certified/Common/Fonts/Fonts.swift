import UIKit
import SwiftUI

enum Fonts {

    // MARK: - Common

    enum Common {

        // Tab Bar

        static let tabBarItemFont = AllFonts(
            systemFont: .systemFont(ofSize: 10, weight: .medium),
            knifeTalkFont: UIFont(name: "GreenFuz", size: 12)!
        )

        // Nav Bar

        static let navBarLargeTitleFont = AllFonts(
            systemFont: .systemFont(ofSize: 34, weight: .bold),
            knifeTalkFont: UIFont(name: "GreenFuz", size: 38)!
        )

        static let navBarTitleFont = AllFonts(
            systemFont: .systemFont(ofSize: 17, weight: .semibold),
            knifeTalkFont: UIFont(name: "GreenFuz", size: 20)!
        )
    }
}

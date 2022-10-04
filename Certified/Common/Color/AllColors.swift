import UIKit
import SwiftUI

struct AllColors {
    let systemSupportedColor: UIColor
    let knifeTalkColor: UIColor

    init(lightColor: UIColor, darkColor: UIColor, knifeTalkColor: UIColor) {
        self.systemSupportedColor = UIColor(lightColor: lightColor, darkColor: darkColor)
        self.knifeTalkColor = knifeTalkColor
    }

    func uiKitColor(for theme: ThemeManager.Theme) -> UIColor {
        self[keyPath: theme.allColorsKeyPath]
    }

    func swiftUIColor(for theme: ThemeManager.Theme) -> Color {
        self[keyPath: theme.allColorsKeyPath].swiftUIColor
    }
}

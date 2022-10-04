import UIKit

struct AllFonts {
    let systemFont: UIFont
    let knifeTalkFont: UIFont

    func font(for theme: ThemeManager.Theme) -> UIFont {
        self[keyPath: theme.allFontsKeyPath]
    }
}

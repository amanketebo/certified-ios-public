import UIKit

enum DynamicFonts {

    // MARK: - Methods

    static func systemExtraLargeTitle(maximumPoints: CGFloat? = nil) -> UIFont {
        let font = UIFont.systemFont(ofSize: 75, weight: .regular)
        return scaledFont(font: font, maximumPoints: maximumPoints)
    }

    static func systemLargeTitle(maximumPoints: CGFloat? = nil) -> UIFont {
        let font = UIFont.systemFont(ofSize: 34, weight: .regular)
        return scaledFont(font: font, maximumPoints: maximumPoints)
    }

    static func systemHeadline(maximumPoints: CGFloat? = nil) -> UIFont {
        let font = UIFont.preferredFont(forTextStyle: .headline)
        return scaledFont(font: font, maximumPoints: maximumPoints)
    }

    static func systemSubheadline(maximumPoints: CGFloat? = nil) -> UIFont {
        let font = UIFont.preferredFont(forTextStyle: .subheadline)
        return scaledFont(font: font, maximumPoints: maximumPoints)
    }

    static func systemFootnote(maximumPoints: CGFloat? = nil) -> UIFont {
        let font = UIFont.preferredFont(forTextStyle: .footnote)
        return scaledFont(font: font, maximumPoints: maximumPoints)
    }

    private static func scaledFont(font: UIFont, maximumPoints: CGFloat? = nil) -> UIFont {
        if let maximumPoints = maximumPoints {
            return UIFontMetrics.default.scaledFont(for: font, maximumPointSize: maximumPoints)
        } else {
            return UIFontMetrics.default.scaledFont(for: font)
        }
    }
}

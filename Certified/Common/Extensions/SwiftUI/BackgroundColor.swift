import SwiftUI

struct BackgroundColor: ViewModifier {

    @EnvironmentObject var themeManager: ThemeManager

    let allColors: AllColors

    init(allColors: AllColors) {
        self.allColors = allColors
    }

    func body(content: Content) -> some View {
        content.background(allColors.swiftUIColor(for: themeManager.currentTheme))
    }
}

extension View {
    
    func background(_ allColors: AllColors) -> some View {
        modifier(BackgroundColor(allColors: allColors))
    }
}

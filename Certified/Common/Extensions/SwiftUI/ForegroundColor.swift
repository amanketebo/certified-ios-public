import SwiftUI

struct ForegroundColor: ViewModifier {

    @EnvironmentObject var themeManager: ThemeManager

    let allColors: AllColors

    init(allColors: AllColors) {
        self.allColors = allColors
    }

    func body(content: Content) -> some View {
        content.foregroundColor(allColors.swiftUIColor(for: themeManager.currentTheme))
    }
}


extension View {
    
    func foregroundColor(_ allColors: AllColors) -> some View {
        modifier(ForegroundColor(allColors: allColors))
    }
}

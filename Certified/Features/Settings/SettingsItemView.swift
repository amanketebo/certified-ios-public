import SwiftUI

struct SettingsItemView: View {

    // MARK: - Nested Types

    enum SettingsItemType {

        case tipJar
        case theme
    }

    // MARK: - Properties

    @EnvironmentObject var themeManager: ThemeManager
    @State private var themeSelection = ThemeManager.shared.currentTheme
    
    private let itemType: SettingsItemType
    private let userDefaults: UserDefaults

    var body: some View {
        view.customSettingsItemStyle(for: themeManager.currentTheme)
    }

    @ViewBuilder
    private var view: some View {
        switch itemType {
        case .tipJar:
            let model = SettingsInfoModel(
                imageSystemName: "hand.thumbsup.fill",
                title: LocalizedString.Settings.tipJarTitle,
                description: LocalizedString.Settings.tipJarDescription,
                shouldShowChevron: true
            )
            SettingsInfoView(model: model)
        case .theme:
            let model = SettingsInfoModel(
                imageSystemName: "paintbrush.fill",
                title: "Theme",
                description: "Set the color way of the entire app.",
                shouldShowChevron: false
            )
            VStack(alignment: .leading) {
                SettingsInfoView(model: model)
                Picker("Theme Picker", selection: $themeSelection) {
                    Text("System").tag(ThemeManager.Theme.system)
                    Text("Light").tag(ThemeManager.Theme.light)
                    Text("Dark").tag(ThemeManager.Theme.dark)
                    if themeManager.hasUnlockedKnifeTalkTheme {
                        Text("Knife Talk").tag(ThemeManager.Theme.knifeTalk)
                    }
                }
                .pickerStyle(.segmented)
            }
            .onChange(of: themeSelection) { newValue in
                themeManager.currentTheme = newValue
            }
        }
    }

    // MARK: - Init

    init(itemType: SettingsItemType, userDefaults: UserDefaults = .standard) {
        self.itemType = itemType
        self.userDefaults = userDefaults
    }
}

struct SettingsItemStyle: ViewModifier {
    let theme: ThemeManager.Theme

    func body(content: Content) -> some View {
        content
            .padding(EdgeInsets(top: 20, leading: 16, bottom: 20, trailing: 16))
            .background(Colors.Common.cellBackgroundColor)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Colors.Common.cellBorderColor.swiftUIColor(for: theme), lineWidth: 1)
            )
    }
}

extension View {
    func customSettingsItemStyle(for theme: ThemeManager.Theme) -> some View {
        modifier(SettingsItemStyle(theme: theme))
    }
}

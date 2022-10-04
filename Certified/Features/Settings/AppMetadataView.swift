import SwiftUI

struct AppMetadataView: View {

    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        VStack(spacing: 2) {
            LinearGradient(
                colors: [
                    Colors.SettingsTab.certifiedGradientStartColor.swiftUIColor(for: themeManager.currentTheme),
                    Colors.SettingsTab.certifiedGradientEndColor.swiftUIColor(for: themeManager.currentTheme)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
            .mask({
                Text("Certified")
                    .font(.system(size: 12))
                    .fontWeight(.bold)
            })
            Text(AppMetadata.formattedVersionAndBuildNumber ?? "")
                .font(.system(size: 10))
                .fontWeight(.regular)
                // TODO: Look into why placement matters here
                .foregroundColor(Colors.SettingsTab.versionBuildInfoTitleColor)

        }
    }
}

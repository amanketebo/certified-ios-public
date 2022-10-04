import SwiftUI

struct CoversEmptyStateView: View {

    let viewModel: CoversViewModel
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        Spacer()
        VStack(spacing: 16) {
            VStack(spacing: 4) {
                Text("No Covers Added")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(Colors.Common.titleTextColor)
                Text("Head over to the create tab to make one")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(Colors.CoversTab.createCoverButtonMessageColor)
            }
            Button {
                viewModel.switchToCreateTabAndBeginEditing()
            } label: {
                Text("Create Cover")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Colors.CoversTab.createCoverButtonTitleColor)
                    .padding(EdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15))
                    .roundedBackground(
                        backgroundColor: Colors.CoversTab.createCoverButtonBackgroundColor.swiftUIColor(for: themeManager.currentTheme),
                        borderColor: Colors.CoversTab.createCoverButtonBorderColor.swiftUIColor(for: themeManager.currentTheme),
                        lineWidth: 1,
                        cornerRadius: 11
                    )
                    .shadow(
                        color: Colors.CoversTab.createCoverButtonShadowColor.swiftUIColor(for: themeManager.currentTheme),
                        radius: 15, x: 0, y: 0
                    )
            }
        }
        Spacer()
    }
}

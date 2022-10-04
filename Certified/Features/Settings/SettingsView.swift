import SwiftUI

struct SettingsView: View {

    // MARK: - Properties

    @ObservedObject private var viewModel: SettingsViewModel
    @EnvironmentObject var themeManager: ThemeManager
    @State var isDebugMenuPresented = false

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 8) {
                NavigationLink(isActive: $viewModel.isShowingTipJarView) {
                    let viewModel = TipJarViewModel(
                        appTabBarController: viewModel.appTabBarController,
                        iapManager: viewModel.iapManager
                    )
                    TipJarView(viewModel: viewModel)
                        .environmentObject(themeManager)
                } label: {
                    SettingsItemView(itemType: .tipJar)
                        .environmentObject(themeManager)
                }
                SettingsItemView(itemType: .theme)
            }
            .padding(EdgeInsets(top: 12, leading: 12, bottom: 0, trailing: 12))
            Spacer(minLength: 32)
            AppMetadataView()
                .onTapGesture(count: 3) { isDebugMenuPresented = true }
        }
        .navigationTitle(LocalizedString.Settings.navBarTitle)
        .background(Colors.Common.viewBackgroundColor)
        .sheet(isPresented: $isDebugMenuPresented) {
            DebugMenuView(featureFlagsManager: FeatureFlagsManager.shared)
        }
    }

    // MARK: - Init

    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
    }
}

struct SettingsView_Previews: PreviewProvider {
    static let viewModel = SettingsViewModel(
        appTabBarController: AppTabBarController(),
        iapManager: InAppPurchaseManager()
    )

    static var previews: some View {
        NavigationView {
            SettingsView(viewModel: viewModel)
        }
        .navigationTitle(LocalizedString.Settings.navBarTitle)
        .preferredColorScheme(.light)

        NavigationView {
            SettingsView(viewModel: viewModel)
        }
        .navigationTitle(LocalizedString.Settings.navBarTitle)
        .preferredColorScheme(.dark)
    }
}

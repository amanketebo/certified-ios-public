import SwiftUI

struct TipJarView: View {

    // MARK: - Properties

    @ObservedObject private var viewModel: TipJarViewModel
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 32) {
                AboutMeView(viewModel: viewModel)
                VStack(alignment: .center, spacing: 8) {
                    if viewModel.shouldShowProgressView {
                        ProgressView()
                    } else {
                        ForEach(viewModel.tipOptions(using: themeManager.currentTheme)) { tipOption in
                            TipOptionView(tipOption: tipOption, tipJarViewModel: viewModel)
                        }
                    }
                }
            }
            .padding(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12))
            .alert("Oops", isPresented: $viewModel.isErrorAlertPresented, actions: {
                Button("OK") { viewModel.isErrorAlertPresented = false }
            }, message: {
                Text("Something went wrong. Please try again later.")
            })
            .task {
                await viewModel.fetchTipOptions()
            }
        }
        .navigationTitle(LocalizedString.Settings.tipJarNavBarTitle)
        .background(Colors.Common.viewBackgroundColor)
    }

    // MARK: - Init

    init(viewModel: TipJarViewModel) {
        self.viewModel = viewModel
    }
}

struct TipJarView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = TipJarViewModel(appTabBarController: AppTabBarController(), iapManager: InAppPurchaseManager())
        TipJarView(viewModel: viewModel)
    }
}

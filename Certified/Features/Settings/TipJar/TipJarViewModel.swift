import Foundation
import UIKit

class TipJarViewModel: ObservableObject {

    // MARK: - Properties

    let appTabBarController: AppTabBarController?
    let iapManager: InAppPurchaseManager

    @Published var tipOptions = [TipOption]()
    @Published var hasAttemptedFetchingTipOptions = false
    @Published var isErrorAlertPresented = false

    var shouldShowProgressView: Bool {
        tipOptions.isEmpty && hasAttemptedFetchingTipOptions == false
    }

    // MARK: - Init

    init(appTabBarController: AppTabBarController?, iapManager: InAppPurchaseManager) {
        self.appTabBarController = appTabBarController
        self.iapManager = iapManager
    }

    // MARK: - Fetch Tips

    func fetchTipOptions() async {
        do {
            let iapProducts = try await iapManager.fetchAvailableTipProducts()
            let tipOptions = iapProducts.map { TipOption(iapProduct: $0, theme: ThemeManager.shared.currentTheme) }

            await update(tipOptions: tipOptions, hasAttemptedFetchingTipOptions: true)
        } catch {
            await update(tipOptions: [], hasAttemptedFetchingTipOptions: true)
        }
    }

    func tipOptions(using theme: ThemeManager.Theme) -> [TipOption] {
        tipOptions.map { TipOption(iapProduct: $0.iapProduct, theme: theme) }
    }

    // MARK: - Purchase Tip

    func purchase(iapProduct: IAPProduct) {
        appTabBarController?.showLoadingViewController()
        Task {
            do {
                try await iapManager.purchase(iapProduct: iapProduct)
                await appTabBarController?.dismissLoadingViewController()
            } catch {
                await appTabBarController?.dismissLoadingViewController()
                await update(isErrorPresented: true)
            }
        }
    }

    // MARK: - Open Social App

    func openTwitter() {
        let application = UIApplication.shared
        let appURL = URL(string: "twitter://user?screen_name=aktwofour")
        let websiteURL = URL(string: "https://twitter.com/aktwofour")

        if let twitterAppURL = appURL, application.canOpenURL(twitterAppURL) {
            application.open(twitterAppURL)
        } else if let twitterWebsiteURL = websiteURL {
            appTabBarController?.showTwitterSafariViewController(url: twitterWebsiteURL)
        }
    }

    // MARK: - Update Properties

    @MainActor
    private func update(tipOptions: [TipOption], hasAttemptedFetchingTipOptions: Bool) {
        self.tipOptions = tipOptions
        self.hasAttemptedFetchingTipOptions = hasAttemptedFetchingTipOptions
    }

    @MainActor
    private func update(isErrorPresented: Bool) {
        isErrorAlertPresented = true
    }
}

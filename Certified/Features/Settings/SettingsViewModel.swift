import Foundation
import StoreKit
import Combine

class SettingsViewModel: ObservableObject {

    // MARK: - Properties

    weak var appTabBarController: AppTabBarController?
    let iapManager: InAppPurchaseManager

    // MARK: Combine

    @Published var isShowingTipJarView = false

    // MARK: - Init

    init(appTabBarController: AppTabBarController, iapManager: InAppPurchaseManager) {
        self.iapManager = iapManager
        self.appTabBarController = appTabBarController
    }
}

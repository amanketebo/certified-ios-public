import UIKit
import SwiftUI
import StoreKit
import Combine

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // MARK: - Properties

    var window: UIWindow?
    private let appTabBarController = AppTabBarController()
    private let iapManager = InAppPurchaseManager()
    private let themeManager = ThemeManager.shared
    private let userDefaults = UserDefaults.standard
    private var numberOfTimesForegrounded = 0
    private var subscriptions: Set<AnyCancellable> = []

    // MARK: - Lifecycle

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        setUpApp(in: scene)
        setUpTheme()
        iapManager.listenForTransactions()
        listenForThemeUpdates()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        numberOfTimesForegrounded += 1
        beginPeekingCharacterIfNeeded()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        endPeekingIfNeeded()
    }
    
    // MARK: - Set Up
    
    private func setUpApp(in scene: UIScene) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)

        window.rootViewController = setUpTabController(with: window.safeAreaInsets)
        self.window = window
        self.window?.makeKeyAndVisible()
    }
    
    private func setUpTabController(with rootInsets: UIEdgeInsets) -> AppTabBarController {
        let database = Database()

        // Create Tab
        let createViewController = CreateViewController()
        let createNavigationController = CreateNavigationController(rootViewController: createViewController)
        let albumCoverViewModel = AlbumCoverViewModel(
            context: .create(superviewWidth: 0),
            database: database,
            delegate: createViewController
        )
        let albumCoverView = AlbumCoverView(viewModel: albumCoverViewModel)
            .environmentObject(themeManager)
            .environment(\.rootSafeAreaInsets, rootInsets.swiftUIInsets)
        let hostingController = UIHostingController(rootView: albumCoverView)
        createViewController.albumCoverViewModel = albumCoverViewModel
        createViewController.albumCoverHostingController = hostingController
        createViewController.heightUpdateClosure = { viewBounds in
            hostingController.sizeThatFits(in: viewBounds.size).height
        }

        // Covers Tab
        let coversViewModel = CoversViewModel(database: database, appTabBarController: appTabBarController)
        let coversView = CoversView(viewModel: coversViewModel)
            .environmentObject(themeManager)
            .environment(\.rootSafeAreaInsets, rootInsets.swiftUIInsets)
        let coversHostingController = UIHostingController(rootView: coversView)
        let coversNavigationController = CoversNavigationController(
            rootViewController: coversHostingController
        )

        // Settings Tab
        let settingsViewModel = SettingsViewModel(appTabBarController: appTabBarController, iapManager: iapManager)
        let settingsView = SettingsView(viewModel: settingsViewModel)
            .environmentObject(themeManager)
            .environment(\.rootSafeAreaInsets, rootInsets.swiftUIInsets)
        let settingsHostingController = UIHostingController(rootView: settingsView)
        let settingsNavigationController = SettingsNavigationController(
            rootViewController: settingsHostingController
        )

        appTabBarController.setViewControllers(
            [createNavigationController, coversNavigationController, settingsNavigationController],
            animated: false
        )
        
        return appTabBarController
    }

    private func setUpTheme() {
        guard let savedTheme = themeManager.currentSavedTheme else { return }
        
        themeManager.currentTheme = savedTheme
    }

    private func listenForThemeUpdates() {
        themeManager.$currentTheme.sink { [weak self] currentTheme in
            guard let self = self else { return }

            self.window?.overrideUserInterfaceStyle = currentTheme.interfaceStyle
            self.themeManager.saveCurrentTheme(currentTheme)
        }.store(in: &subscriptions)
    }

    // MARK: - Peeking Character

    private func beginPeekingCharacterIfNeeded() {
        let hasForegroundedThreeTimes = numberOfTimesForegrounded % 3 == 0
        let shouldPeekCharacter = hasForegroundedThreeTimes
        guard shouldPeekCharacter else { return }

        appTabBarController.peekCharacter(numberOfTimes: 3)
    }

    private func endPeekingIfNeeded() {
        appTabBarController.endPeekingIfNeeded()
    }
}

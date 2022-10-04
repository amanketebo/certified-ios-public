import UIKit
import SpriteKit
import SafariServices
import Combine

class AppTabBarController: UITabBarController {
    
    // MARK: Properties
    
    private let onboardingViewModel = OnboardingViewModel()
    private let themeManager = ThemeManager.shared

    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: View Controllers
    
    private var createViewController: CreateViewController? {
        let createNavigationController = viewControllers?
            .first{ $0 is CreateNavigationController } as? CreateNavigationController
        return createNavigationController?.viewControllers.first as? CreateViewController
    }

    private let peekingSpriteKitView: PeekingCharacterSKView = {
        let skView = PeekingCharacterSKView()
        skView.backgroundColor = .clear
        return skView
    }()

    private lazy var peekingCharacterScene: PeekingCharacterScene = {
        let scene = PeekingCharacterScene(character: .drake, size: view.bounds.size)
        return scene
    }()

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabBar()
        setUpThemeListener()
        // TODO: Decide on if this peeking character is still needed
        // setUpPeekingCharacter()
    }
    
    // MARK: - Set Up
    
    private func setUpTabBar() {
        tabBar.isTranslucent = true
    }

    private func setUpPeekingCharacter() {
        view.addConstrained(peekingSpriteKitView, isSafeAreaLayout: false)
        peekingSpriteKitView.presentScene(peekingCharacterScene)
    }

    private func setUpThemeListener() {
        themeManager.$currentTheme.sink { [weak self] currentTheme in
            self?.updateTabBar(for: currentTheme)
        }.store(in: &subscriptions)
    }

    // MARK: - Update Theme

    private func updateTabBar(for theme: ThemeManager.Theme) {
        let tabBarAppearance = UITabBarAppearance()
        let tabBarItemAppearance = UITabBarItemAppearance()

        tabBarItemAppearance.normal.titleTextAttributes = [
            .font: Fonts.Common.tabBarItemFont.font(for: theme),
            .foregroundColor: Colors.Common.tabBarNormalTintColor.uiKitColor(for: theme),
        ]
        tabBarItemAppearance.selected.titleTextAttributes = [
            .font: Fonts.Common.tabBarItemFont.font(for: theme),
            .foregroundColor: Colors.Common.tabBarSelectedTintColor.uiKitColor(for: theme)
        ]

        tabBarAppearance.stackedLayoutAppearance = tabBarItemAppearance
        tabBar.standardAppearance = tabBarAppearance
        tabBar.scrollEdgeAppearance = tabBarAppearance
        tabBar.backgroundColor = .clear
        tabBar.tintColor = Colors.Common.tabBarSelectedTintColor.uiKitColor(for: theme)
        tabBar.setNeedsLayout()
    }
    
    // MARK: - Showing View Controllers
    
    func showOnboardingIfNeeded() {
        guard !onboardingViewModel.hasShownOnboarding else { return }
        guard let createViewController = createViewController else { return }

        let onboardingViewController = OnboardingViewController(createViewController: createViewController)
        onboardingViewController.modalPresentationStyle = .overCurrentContext
        onboardingViewController.modalTransitionStyle = .crossDissolve
        present(onboardingViewController, animated: true)
        
        onboardingViewModel.set(hasShownOnboarding: true)
    }

    func showLoadingViewController() {
        let loadingViewController = FullScreenLoadingViewController()
        loadingViewController.modalPresentationStyle = .overFullScreen
        loadingViewController.modalTransitionStyle = .crossDissolve
        present(loadingViewController, animated: true)
    }

    func stopLoadingAnimation() {
        guard let fullScreenLoadingViewController = presentedViewController as? FullScreenLoadingViewController else {
            return
        }

        fullScreenLoadingViewController.stopLoadingAnimation()
    }

    @MainActor
    func dismissLoadingViewController() async {
        guard presentedViewController is FullScreenLoadingViewController else { return }

        await withCheckedContinuation { continuation in
            dismiss(animated: true) { continuation.resume() }
        }
    }

    func showTwitterSafariViewController(url: URL) {
        let twitterSafariViewController = SFSafariViewController(url: url)
        twitterSafariViewController.modalPresentationStyle = .pageSheet
        present(twitterSafariViewController, animated: true)
    }

    // MARK: - Selecting Tabs

    func switchToCreateTabAndBeginEditing() {
        selectedIndex = 0

        guard let createViewController = createViewController else { return }

        createViewController.beginEditing()
    }

    // MARK: - Peeking Character

    func peekCharacter(numberOfTimes: Int) {
        peekingCharacterScene.repeatedlyPeek(numberOfTimes: numberOfTimes)
    }

    func endPeekingIfNeeded() {
        peekingCharacterScene.endPeekingIfNeeded()
    }
}

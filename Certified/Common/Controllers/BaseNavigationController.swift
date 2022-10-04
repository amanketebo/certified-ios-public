import UIKit
import Combine

class BaseNavigationController: UINavigationController {

    // MARK: - Properties

    private let themeManager = ThemeManager.shared
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setUpThemeListener()
    }

    // MARK: - Set Up

    private func setUpThemeListener() {
        themeManager.$currentTheme.sink { [weak self] currentTheme in
            self?.updateNavigationBarAppearance(for: currentTheme)
        }.store(in: &subscriptions)
    }

    private func setUpNavigationBar() {
        navigationBar.prefersLargeTitles = true
    }

    // MARK: - Update

    private func updateNavigationBarAppearance(for theme: ThemeManager.Theme) {
        let appearance = UINavigationBarAppearance()

        appearance.backgroundColor = .clear
        appearance.titleTextAttributes = [
            .foregroundColor: Colors.Common.navBarTitleColor.uiKitColor(for: theme),
            .font: Fonts.Common.navBarTitleFont.font(for: theme)
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: Colors.Common.navBarTitleColor.uiKitColor(for: theme),
            .font: Fonts.Common.navBarLargeTitleFont.font(for: theme)
        ]

        navigationBar.isTranslucent = true
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.tintColor = Colors.Common.navBarTintColor.uiKitColor(for: theme)
    }
}

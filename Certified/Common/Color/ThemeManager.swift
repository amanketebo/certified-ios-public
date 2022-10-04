import Foundation
import UIKit
import Combine
import SwiftUI

class ThemeManager: ObservableObject {

    // MARK: - Nested Types

    enum Theme: Int {

        case system
        case light
        case dark
        case knifeTalk

        var interfaceStyle: UIUserInterfaceStyle {
            switch self {
            case .system:
                return .unspecified
            case .light:
                return .light
            case .dark, .knifeTalk:
                return .dark
            }
        }

        var allColorsKeyPath: KeyPath<AllColors, UIColor> {
            switch self {
            case .system, .light, .dark:
                return \.systemSupportedColor
            case .knifeTalk:
                return \.knifeTalkColor
            }
        }

        var allFontsKeyPath: KeyPath<AllFonts, UIFont> {
            switch self {
            case .system, .light, .dark:
                return \.systemFont
            case .knifeTalk:
                return \.knifeTalkFont
            }
        }
    }

    // MARK: - Properties

    static let shared = ThemeManager(window: nil, currentTheme: .system)

    @Published var currentTheme = Theme.system
    weak var window: UIWindow?

    private let notificationCenter: NotificationCenter
    private let userDefaults: UserDefaults
    private var subscriptions = Set<AnyCancellable>()


    // MARK: Computed

    var hasUnlockedKnifeTalkTheme: Bool {
        userDefaults.bool(forKey: UserDefaultsKeys.hasUnlockedKnifeTalkTheme.rawValue)
    }

    var currentSavedTheme: Theme? {
        let savedThemeRawValue = userDefaults.integer(forKey: UserDefaultsKeys.currentTheme.rawValue)
        guard let savedTheme = ThemeManager.Theme(rawValue: savedThemeRawValue) else { return nil }
        
        return savedTheme
    }

    // MARK: - Init

    init(
        window: UIWindow?,
        currentTheme: Theme,
        notificationCenter: NotificationCenter = .default,
        userDefaults: UserDefaults = .standard
    ) {
        self.window = window
        self.currentTheme = currentTheme
        self.notificationCenter = notificationCenter
        self.userDefaults = userDefaults
    }

    // MARK: Methods

    func updateHasUnlockedKnifeTalkTheme(_ value: Bool) {
        userDefaults.set(value, forKey: UserDefaultsKeys.hasUnlockedKnifeTalkTheme.rawValue)
    }

    func saveCurrentTheme(_ currentTheme: Theme = ThemeManager.shared.currentTheme) {
        userDefaults.set(currentTheme.rawValue, forKey: UserDefaultsKeys.currentTheme.rawValue)
    }
}

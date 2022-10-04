import Foundation

class FeatureFlagsManager {

    // MARK: - Properties

    private let userDefaults: UserDefaults
    private let notificationCenter: NotificationCenter

    // MARK: Flags

    private(set) var isFaceSwapPrototypeEnabled = false

    static let shared = FeatureFlagsManager()

    init(userDefaults: UserDefaults = .standard, notificationCenter: NotificationCenter = .default) {
        self.userDefaults = userDefaults
        self.notificationCenter = notificationCenter

        isFaceSwapPrototypeEnabled = userDefaults.bool(forKey: UserDefaultsKeys.isFaceSwapPrototypeEnabled.rawValue)
    }

    func updateFaceSwapPrototypeEnabled(_ newValue: Bool) {
        isFaceSwapPrototypeEnabled = newValue
        userDefaults.set(newValue, forKey: UserDefaultsKeys.isFaceSwapPrototypeEnabled.rawValue)
        notificationCenter.post(name: .featureFlagsDidUpdate, object: nil)
    }
}

import Foundation

class OnboardingViewModel {
    
    // MARK: - Properties
    
    var hasShownOnboarding: Bool {
        return userDefaults.bool(forKey: UserDefaultsKeys.hasShownOnboarding.rawValue)
    }
    
    private let userDefaults: UserDefaults
    
    // MARK: - Init
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    // MARK: - Methods
    
    func set(hasShownOnboarding: Bool) {
        userDefaults.set(hasShownOnboarding, forKey: UserDefaultsKeys.hasShownOnboarding.rawValue)
    }
}

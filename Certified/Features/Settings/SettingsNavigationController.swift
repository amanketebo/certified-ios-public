import UIKit

class SettingsNavigationController: BaseNavigationController {

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabBarItem()
    }

    // MARK: - Set Up

    private func setUpTabBarItem() {
        tabBarItem = UITabBarItem(
            title: LocalizedString.TabBar.settingsTitle,
            image: UIImage(systemName: "gearshape"),
            selectedImage: UIImage(systemName: "gearshape.fill")
        )
    }
}

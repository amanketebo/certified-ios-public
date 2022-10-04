import UIKit

class CoversNavigationController: BaseNavigationController {
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabBarItem()
    }
    
    // MARK: - Set Up
    
    private func setUpTabBarItem() {
        tabBarItem = UITabBarItem(
            title: LocalizedString.TabBar.coversTitle,
            image: UIImage(systemName: "rectangle.grid.2x2"),
            selectedImage: UIImage(systemName: "rectangle.grid.2x2.fill")
        )
    }
}

import UIKit

class CreateNavigationController: BaseNavigationController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabBarItem()
    }
    
    // MARK: - Set Up
    
    private func setUpTabBarItem() {
        tabBarItem = UITabBarItem(
            title: LocalizedString.TabBar.createTitle,
            image: UIImage(systemName: "paintpalette"),
            selectedImage: UIImage(systemName: "paintpalette.fill")
        )
    }
}

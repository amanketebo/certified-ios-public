import UIKit

extension UIViewController {
    var appTabBarController: AppTabBarController? {
        return tabBarController as? AppTabBarController
    }
}

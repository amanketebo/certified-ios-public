import UIKit
import Vision

class PrototypeViewController: UIViewController {

    // MARK: - Nested Types

    private enum PrototypeOption {
        case photos
        case videos
    }

    // MARK: - Properties

    private let themeManager = ThemeManager.shared
    private var prototypeOption: PrototypeOption?

    // MARK: Views

    private let containerView = UIView()

    // MARK: Child View Controllers

    private let photosVisionViewController = PhotosVisionViewController()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpContainerView()
    }

    // MARK: - Set Up

    private func setUpView() {
        view.backgroundColor = Colors.Common.viewBackgroundColor.uiKitColor(for: themeManager.currentTheme)
    }

    private func setUpContainerView() {
        view.addConstrained(containerView,left: 16, top: 0, right: 16, bottom: 0)
        addChildViewController(for: .photos)
    }

    private func addChildViewController(for prototypeOption: PrototypeOption) {
        guard prototypeOption != self.prototypeOption else { return }

        switch prototypeOption {
        case .photos:
            containerView.addConstrained(photosVisionViewController.view)
            addChild(photosVisionViewController)
            photosVisionViewController.didMove(toParent: self)
        case .videos:
            break
        }

        self.prototypeOption = prototypeOption
    }
}

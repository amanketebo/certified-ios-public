import UIKit
import SwiftUI
import Combine

class OnboardingViewController: UIViewController {
    
    // MARK: - Properties
    
    private weak var createViewController: CreateViewController?
    private let themeManager = ThemeManager.shared
    private var subscriptions = Set<AnyCancellable>()
    private lazy var albumCoverViewModel = {
        return AlbumCoverViewModel(context: .onboarding(superviewWidth: view.bounds.size.width))
    }()
    private let visualEffectView = UIVisualEffectView()

    private lazy var albumCoverView = {
        return AlbumCoverView(viewModel: albumCoverViewModel)
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton()
        let xImage = UIImage(systemName: "xmark")?.withTintColor(.white).withRenderingMode(.alwaysOriginal)
        
        button.setImage(xImage, for: .normal)
        button.backgroundColor = Colors.CreateTab.onboardingCloseButtonBackgroundColor.uiKitColor(for: themeManager.currentTheme)
        button.layer.borderColor = Colors.CreateTab.onboardingCloseButtonBorderColor.uiKitColor(for: themeManager.currentTheme).cgColor
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(tapToDismiss), for: .touchUpInside)

        return button
    }()

    private let infoView = UIView()
    private let infoViewLabel = UILabel()
    
    private var hostingViewControllerConvertedFrame: CGRect? {
        guard let createScreenHostingViewControllerView = createViewController?.albumCoverHostingController?.view else {
            return nil
        }
        
        var convertedFrame = createViewController?.view.convert(
            createScreenHostingViewControllerView.frame,
            to: self.view.coordinateSpace
        )
        // Update frame in order to take into account the borders of the view which spills outside of its frame.
        convertedFrame?.origin.x -= albumCoverViewModel.borderWidth
        convertedFrame?.origin.y -= albumCoverViewModel.borderWidth
        let widthHeightAdditionalValue = albumCoverViewModel.borderWidth * 2
        convertedFrame?.size.width +=  widthHeightAdditionalValue
        convertedFrame?.size.height +=  widthHeightAdditionalValue
        
        return convertedFrame
    }
    
    // MARK: - Init
    
    init(createViewController: CreateViewController) {
        self.createViewController = createViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBackgroundColor()
        setUpVisualEffectView()
        setUpMaskLayer()
        setUpInfoView()
        setUpCloseButton()
        setUpPassThroughView()
        setUpThemeListener()
    }
    
    // MARK: - Set Up
    
    private func setUpBackgroundColor() {
        view.backgroundColor = .clear
    }

    private func setUpPassThroughView() {
        guard let passthroughFrame = hostingViewControllerConvertedFrame,
              let albumCoverHostingController = createViewController?.albumCoverHostingController else {
            return
        }
        let passthroughView = OnboardingPassthroughView(
            frame: passthroughFrame,
            forwardView: albumCoverHostingController.view,
            beforeForwardAction: { [weak self] in self?.dismiss(animated: false) }
        )
        passthroughView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(passthroughView)
    }

    private func setUpVisualEffectView() {
        visualEffectView.effect = UIBlurEffect(style: .dark)
        view.addConstrained(visualEffectView, isSafeAreaLayout: false)
    }
    
    private func setUpMaskLayer() {
        guard let hostingViewControllerConvertedFrame = hostingViewControllerConvertedFrame else { return }
        
        let shapeLayer = CAShapeLayer()
        let path = CGMutablePath()
        let viewBezierPath = UIBezierPath(roundedRect: view.frame, cornerRadius: 0)
        let createScreenAlbumCoverViewBezierPath = UIBezierPath(
            roundedRect: hostingViewControllerConvertedFrame,
            cornerRadius: albumCoverViewModel.cornerRadius
        )
        
        path.addPath(viewBezierPath.cgPath)
        path.addPath(createScreenAlbumCoverViewBezierPath.cgPath)
        shapeLayer.fillRule = .evenOdd
        shapeLayer.path = path
        visualEffectView.layer.mask = shapeLayer
    }
    
    private func setUpInfoView() {
        guard let hostingViewControllerConvertedFrame = hostingViewControllerConvertedFrame else { return }

        infoView.backgroundColor = Colors.CreateTab.onboardingInfoViewBackgroundColor.uiKitColor(for: themeManager.currentTheme)
        infoView.translatesAutoresizingMaskIntoConstraints = false
        infoView.frame = CGRect(
            x: hostingViewControllerConvertedFrame.minX,
            y: hostingViewControllerConvertedFrame.maxY + 24,
            width: hostingViewControllerConvertedFrame.width,
            height: 40
        )
        infoView.layer.cornerRadius = 12
        infoView.layer.borderWidth = 2
        infoView.layer.borderColor = Colors.CreateTab.onboardingInfoViewBorderColor.uiKitColor(for: themeManager.currentTheme).cgColor
        view.addSubview(infoView)

        let trailingLeadingSpace: CGFloat = 14
        infoViewLabel.text = "Tap on emoji to begin editing album cover."
        infoViewLabel.textColor = Colors.CreateTab.onboardingInfoViewTextColor.uiKitColor(for: themeManager.currentTheme)
        infoViewLabel.adjustsFontSizeToFitWidth = true
        infoViewLabel.minimumScaleFactor = 0.10
        infoViewLabel.frame = CGRect(
            x: trailingLeadingSpace,
            y: 0,
            width: infoView.bounds.width - (trailingLeadingSpace * 2),
            height: infoView.bounds.height
        )
        infoView.addSubview(infoViewLabel)
    }

    private func setUpCloseButton() {
        let closeButtonSize = CGSize(width: 44, height: 44)
        let totalSpaceBeneathInfoView = view.bounds.size.height - infoView.frame.maxY - closeButtonSize.height

        closeButton.frame = CGRect(
            x: (view.bounds.size.width / 2) - (closeButtonSize.width / 2),
            y: infoView.frame.maxY + totalSpaceBeneathInfoView / 2,
            width: closeButtonSize.width,
            height: closeButtonSize.height
        )
        view.addSubview(closeButton)
        closeButton.layer.cornerRadius = closeButtonSize.height / 2
    }

    private func setUpThemeListener() {
        themeManager.$currentTheme.sink { [weak self] currentTheme in
            self?.setUpColors(for: currentTheme)
        }.store(in: &subscriptions)
    }

    private func setUpColors(for theme: ThemeManager.Theme) {
        closeButton.backgroundColor = Colors.CreateTab.onboardingCloseButtonBackgroundColor.uiKitColor(for: themeManager.currentTheme)
        closeButton.layer.borderColor = Colors.CreateTab.onboardingCloseButtonBorderColor.uiKitColor(for: themeManager.currentTheme).cgColor
        infoView.backgroundColor = Colors.CreateTab.onboardingInfoViewBackgroundColor.uiKitColor(for: themeManager.currentTheme)
        infoView.layer.borderColor =  Colors.CreateTab.onboardingInfoViewBorderColor.uiKitColor(for: themeManager.currentTheme).cgColor
        infoViewLabel.textColor = Colors.CreateTab.onboardingInfoViewTextColor.uiKitColor(for: themeManager.currentTheme)
    }
    
    @objc func tapToDismiss() {
        dismiss(animated: true, completion: nil)
    }
}

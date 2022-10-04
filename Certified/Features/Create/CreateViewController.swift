import UIKit
import SwiftUI
import Combine

class CreateViewController: UIViewController, AlbumCoverViewModelDelegate {
    
    // MARK: - Properties
    
    var albumCoverViewModel: AlbumCoverViewModel?
    var albumCoverHostingController: UIViewController?
    // TODO: Describe workaround
    var heightUpdateClosure: ((CGRect) -> CGFloat)?
    var musicPlayerHostingController: UIViewController?

    lazy var faceSwapPrototypeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "drake"), for: .normal)
        button.addTarget(self, action: #selector(showFaceSwapPrototype), for: .touchUpInside)
        return button
    }()

    private var buttonsView: ButtonsView!
    private let themeManager = ThemeManager.shared
    private let featureFlagsManager = FeatureFlagsManager.shared
    private let musicPlayerViewModel = MusicPlayerViewModel()
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: Constraints
    
    private var albumCoverCenterXConstraint: NSLayoutConstraint!
    private var albumCoverCenterYConstraint: NSLayoutConstraint!
    private var buttonsViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        setUpView()
        setUpAlbumCoverView()
        setUpButtonsView()
        setUpMusicPlayerViewIfNeeded(for: themeManager.currentTheme)
        setUpKeyboardObservers()
        setUpThemeListener()
        setUpFaceSwapPrototypeButton()
        setUpFeatureFlagsListener()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        appTabBarController?.showOnboardingIfNeeded()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if previousTraitCollection != traitCollection {
            buttonsView.updateLayout(for: traitCollection.preferredContentSizeCategory)
        }
    }
    
    // MARK: - Set Up
    
    private func setUpNavBar() {
        navigationItem.title = LocalizedString.Create.navBarTitle
    }
    
    private func setUpView() {
        view.backgroundColor = Colors.Common.viewBackgroundColor.uiKitColor(for: themeManager.currentTheme)
    }
    
    private func setUpAlbumCoverView() {
        guard let albumCoverViewModel = albumCoverViewModel, let albumCoverHostingController = albumCoverHostingController else {
            return
        }

        albumCoverViewModel.updateSuperViewSize(view.bounds.size)
        albumCoverHostingController.view.backgroundColor = Colors.Common.viewBackgroundColor.uiKitColor(for: themeManager.currentTheme)

        addChild(albumCoverHostingController)
        view.addSubview(albumCoverHostingController.view)
        albumCoverHostingController.didMove(toParent: self)


        let height = heightUpdateClosure?(view.bounds) ?? 0
        albumCoverHostingController.view.translatesAutoresizingMaskIntoConstraints = false
        albumCoverCenterXConstraint = albumCoverHostingController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        albumCoverCenterYConstraint = albumCoverHostingController.view.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        NSLayoutConstraint.activate([
            albumCoverCenterXConstraint,
            albumCoverCenterYConstraint,
            albumCoverHostingController.view.heightAnchor.constraint(equalToConstant: height)
        ])
    }
    
    private func setUpButtonsView() {
        let buttons = [
            BackButton { [weak self] in
                self?.endEditing()
            },
            AddCoverButton { [weak self] in
                self?.endEditing()
                self?.albumCoverViewModel?.saveAlbumCover()
            }
        ]
        buttonsView = ButtonsView(buttons: buttons, contentSizeCategory: traitCollection.preferredContentSizeCategory)
        buttonsView.alpha = 0
        view.addConstrained(buttonsView, left: 0, top: nil, right: 0, bottom: nil)

        if let albumCoverHostingController = albumCoverHostingController {
            NSLayoutConstraint.activate([
                buttonsView.topAnchor.constraint(equalTo: albumCoverHostingController.view.bottomAnchor, constant: 0),
            ])
        }
        
        buttonsViewBottomConstraint = view.bottomAnchor.constraint(equalTo: buttonsView.bottomAnchor)
        buttonsViewBottomConstraint.isActive = true
    }

    private func setUpMusicPlayerViewIfNeeded(for theme: ThemeManager.Theme) {
        guard theme == .knifeTalk, musicPlayerHostingController == nil else { return }

        let musicPlayerView = MusicPlayerView(viewModel: musicPlayerViewModel)
        let hostingController = UIHostingController(rootView: musicPlayerView.environmentObject(themeManager))
        musicPlayerHostingController = hostingController
        view.addConstrained(hostingController.view, left: 0, top: nil, right: 0, bottom: 0)
        NSLayoutConstraint.activate([hostingController.view.heightAnchor.constraint(equalToConstant: 64)])
    }
    
    private func setUpKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardDidShow(notification:)),
            name: UIResponder.keyboardDidShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    private func setUpThemeListener() {
        themeManager.$currentTheme.sink { [weak self] currentTheme in
            guard let self = self else { return }
            self.view.backgroundColor = Colors.Common.viewBackgroundColor.uiKitColor(for: currentTheme)
            self.albumCoverHostingController?.view.backgroundColor = Colors.Common.viewBackgroundColor.uiKitColor(for: currentTheme)
            self.musicPlayerHostingController?.view.isHidden = currentTheme != .knifeTalk
        }.store(in: &subscriptions)
    }

    private func setUpFaceSwapPrototypeButton() {
        faceSwapPrototypeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(faceSwapPrototypeButton)
        NSLayoutConstraint.activate([
            faceSwapPrototypeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            faceSwapPrototypeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            faceSwapPrototypeButton.heightAnchor.constraint(equalToConstant: 55),
            faceSwapPrototypeButton.widthAnchor.constraint(equalToConstant: 44)
        ])
        faceSwapPrototypeButton.isHidden = !featureFlagsManager.isFaceSwapPrototypeEnabled
    }

    private func setUpFeatureFlagsListener() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(featureFlagsDidUpdate),
            name: .featureFlagsDidUpdate,
            object: nil
        )
    }

    // MARK: - Editing

    func beginEditing() {
        guard let albumCoverEmoji = albumCoverViewModel?.rows.first?.emojis.first else { return }
        albumCoverViewModel?.turnOnEditMode(for: albumCoverEmoji)
    }
    
    // MARK: - Reacting to Keyboard Changes
    
    @objc func keyboardDidShow(notification: Notification) {
        guard let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let keyboardHeight = keyboardSize.height
        buttonsViewBottomConstraint.constant = keyboardHeight
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        buttonsViewBottomConstraint.constant = 0
    }

    // MARK: - Reacting to Feature Flag Changes

    @objc func featureFlagsDidUpdate() {
        faceSwapPrototypeButton.isHidden = !featureFlagsManager.isFaceSwapPrototypeEnabled
    }
    
    // MARK: - AlbumCoverViewModelDelegate
    
    func didUpdateEditMode(_ editMode: EditMode) {
        let animationClosure: (() -> Void)?
        
        switch editMode {
        case .on:
            animationClosure = { [weak self] in
                guard let self = self else { return }
                
                self.buttonsView.alpha = 1
                if let albumCoverHostingController = self.albumCoverHostingController {
                    self.albumCoverCenterYConstraint?.constant = -(albumCoverHostingController.view.bounds.height / 2 - 16)
                }
            }
            navigationController?.setNavigationBarHidden(true, animated: true)
        case .off:
            animationClosure = { [weak self] in
                guard let self = self else { return }
                
                self.buttonsView.alpha = 0
                self.albumCoverCenterYConstraint?.constant = 0
            }
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
        
        UIView.animate(withDuration: 0.5) {
            animationClosure?()
        }
    }

    func didUpdateEmojis(_ isAllKnifeEmojis: Bool) {
        guard isAllKnifeEmojis && themeManager.currentTheme != .knifeTalk else { return }
        themeManager.currentTheme = .knifeTalk

        guard themeManager.hasUnlockedKnifeTalkTheme == false else { return }
        themeManager.updateHasUnlockedKnifeTalkTheme(true)
        endEditing()
        setUpMusicPlayerViewIfNeeded(for: themeManager.currentTheme)
    }
    
    // MARK: - Tapping Buttons
    
    private func endEditing() {
        albumCoverViewModel?.turnOffEditModeForAllEmojis()
    }

    @objc
    private func showFaceSwapPrototype() {
        let vc = PrototypeViewController()
        vc.modalPresentationStyle = .pageSheet
        vc.modalTransitionStyle = .coverVertical
        present(vc, animated: true)
    }
}

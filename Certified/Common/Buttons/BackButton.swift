import UIKit
import Combine

class BackButton: UIButton {
    
    // MARK: - Properties
    
    var onTapClosure: (() -> Void)?
    private let themeManager = ThemeManager.shared
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(frame: CGRect = .zero, onTap: (() -> Void)? = nil) {
        super.init(frame: frame)
        self.onTapClosure = onTap
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        setUpConfiguration()
        setUpAttributedTitle()
        setUpColors(for: themeManager.currentTheme)
        setUpTarget()
        setUpThemeListener()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set Up
    
    private func setUpConfiguration() {
        var buttonConfig = UIButton.Configuration.plain()
        buttonConfig.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
        self.configuration = buttonConfig
    }
    
    private func setUpTarget() {
        self.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
    }
    
    @objc private func tapButton() {
        onTapClosure?()
    }
    
    private func setUpAttributedTitle() {
        let attributedString: NSMutableAttributedString
        if let image = UIImage(systemName: "arrow.backward.circle") {
            let imageAttachment = NSTextAttachment(image: image)
            attributedString = NSMutableAttributedString(attachment: imageAttachment)
            attributedString.append(NSAttributedString(string: " \(LocalizedString.Create.backButtonTitle)"))
        } else {
            attributedString = NSMutableAttributedString(string: LocalizedString.Create.backButtonTitle)
        }
        let range = NSRange(location: 0, length: attributedString.string.count)
        
        attributedString.addAttributes(
            [.font: DynamicFonts.systemHeadline(), .foregroundColor: UIColor.white],
            range: range
        )
        setAttributedTitle(attributedString, for: .normal)
        titleLabel?.lineBreakMode = .byWordWrapping
        titleLabel?.adjustsFontForContentSizeCategory = true
    }
    
    private func setUpColors(for theme: ThemeManager.Theme) {
        backgroundColor = Colors.CreateTab.backButtonBackgroundColor.uiKitColor(for: theme)
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 1
        layer.shadowRadius = 8
        layer.shadowColor = Colors.CreateTab.backButtonShadowColor.uiKitColor(for: theme).cgColor
        layer.cornerRadius = 12
    }

    private func setUpThemeListener() {
        themeManager.$currentTheme.sink { [weak self] currentTheme in
            self?.setUpColors(for: currentTheme)
        }.store(in: &subscriptions)
    }
}

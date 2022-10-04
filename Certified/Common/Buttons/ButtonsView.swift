import UIKit

class ButtonsView: UIView {
    
    // MARK: - Properties
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        scrollView.contentInset = .init(top: 16, left: 0, bottom: 0, right: 0)
        return scrollView
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .center
        verticalStackView.distribution = .fill
        verticalStackView.spacing = 8
        return verticalStackView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    private var buttons: [UIView]
    
    private var contentSizeCategory: UIContentSizeCategory?
    
    // MARK: - Init
    
    init(frame: CGRect = .zero, buttons: [UIView], contentSizeCategory: UIContentSizeCategory?) {
        self.buttons = buttons
        self.contentSizeCategory = contentSizeCategory
        super.init(frame: frame)
        commonInit(contentSizeCategory: contentSizeCategory)
    }
    
    override init(frame: CGRect) {
        self.buttons = []
        super.init(frame: frame)
        commonInit(contentSizeCategory: nil)
    }
    
    private func commonInit(contentSizeCategory: UIContentSizeCategory?) {
        self.addConstrained(scrollView)
        scrollView.addSubview(contentView)
        contentView.addConstrained(verticalStackView, left: 16, right: 16)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.rightAnchor.constraint(equalTo: scrollView.contentLayoutGuide.rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.leftAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leftAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        updateLayout(for: contentSizeCategory ?? .large)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Button Rows
    
    private func buttonRows(for views: [UIView], numberOfButtonsPerRow: Int) -> [[UIView]] {
        return views.chunked(into: numberOfButtonsPerRow)
    }
    
    private func addButtonRowsToVerticalStackView(buttonRows: [[UIView]]) {
        buttonRows.forEach { buttonRow in
            let horizontalStackView = UIStackView()
            horizontalStackView.axis = .horizontal
            horizontalStackView.spacing = 8
            horizontalStackView.distribution = .fillEqually
            
            buttonRow.forEach { button in
                button.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    button.heightAnchor.constraint(greaterThanOrEqualToConstant: 48)
                ])
                horizontalStackView.addArrangedSubview(button)
            }
            
            let containerView = UIView()
            containerView.addConstrained(horizontalStackView, isSafeAreaLayout: false)
            verticalStackView.addArrangedSubview(containerView)
            
            NSLayoutConstraint.activate([
                containerView.leftAnchor.constraint(equalTo: verticalStackView.leftAnchor),
                containerView.rightAnchor.constraint(equalTo: verticalStackView.rightAnchor),
            ])
        }
    }
    
    // MARK: - Updating Based On Content Size Category
    
    func updateLayout(for contentSizeCategory: UIContentSizeCategory) {
        let numberOfButtonsPerRow = numberOfRows(for: contentSizeCategory)
        let buttonRows = buttonRows(for: buttons, numberOfButtonsPerRow: numberOfButtonsPerRow)
        
        verticalStackView.subviews.forEach { $0.removeFromSuperview() }
        addButtonRowsToVerticalStackView(buttonRows: buttonRows)
    }
    
    private func numberOfRows(for contentSizeCategory: UIContentSizeCategory) -> Int {
        switch contentSizeCategory {
        case UIContentSizeCategory.extraSmall:
            return 2
        case UIContentSizeCategory.small:
            return 2
        case UIContentSizeCategory.medium:
            return 2
        case UIContentSizeCategory.large:
            return 2
        case UIContentSizeCategory.extraLarge:
            return 1
        case UIContentSizeCategory.extraExtraLarge:
            return 1
        case UIContentSizeCategory.extraExtraLarge:
            return 1
        case UIContentSizeCategory.extraExtraExtraLarge:
            return 1
        case UIContentSizeCategory.accessibilityMedium:
            return 1
        case UIContentSizeCategory.accessibilityLarge:
            return 1
        case UIContentSizeCategory.accessibilityExtraLarge:
            return 1
        case UIContentSizeCategory.accessibilityExtraExtraLarge:
            return 1
        case UIContentSizeCategory.accessibilityExtraExtraExtraLarge:
            return 1
        default:
            return 1
        }
    }
}

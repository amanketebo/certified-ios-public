import UIKit

extension UIView {
    
    func addConstrained(
        _ subview: UIView,
        at position: Int? = nil,
        isSafeAreaLayout: Bool = true,
        left: CGFloat? = 0,
        top: CGFloat? = 0,
        right: CGFloat? = 0,
        bottom: CGFloat? = 0
    ) {
        subview.translatesAutoresizingMaskIntoConstraints = false

        if let position = position {
            insertSubview(subview, at: position)
        } else {
            addSubview(subview)
        }
        
        if let left = left {
            let superviewLeftAnchor = isSafeAreaLayout ? self.safeAreaLayoutGuide.leftAnchor : self.leftAnchor
            subview.leftAnchor.constraint(equalTo: superviewLeftAnchor, constant: left).isActive = true
        }
        
        if let top = top {
            let superviewTopAnchor = isSafeAreaLayout ? self.safeAreaLayoutGuide.topAnchor : self.topAnchor
            superviewTopAnchor.constraint(equalTo: subview.topAnchor, constant: -top).isActive = true
        }
        
        if let right = right {
            let superviewRightAnchor = isSafeAreaLayout ? self.safeAreaLayoutGuide.rightAnchor : self.rightAnchor
            superviewRightAnchor.constraint(equalTo: subview.rightAnchor, constant: right).isActive = true
        }
        
        if let bottom = bottom {
            let superviewBottomAnchor = isSafeAreaLayout ? self.safeAreaLayoutGuide.bottomAnchor : self.bottomAnchor
            superviewBottomAnchor.constraint(equalTo: subview.bottomAnchor, constant: bottom).isActive = true
        }
    }
}

import UIKit

class OnboardingPassthroughView: UIView {

    let forwardView: UIView
    let beforeForwardAction: (() -> Void)

    init(frame: CGRect, forwardView: UIView, beforeForwardAction: @escaping (()-> Void)) {
        self.forwardView = forwardView
        self.beforeForwardAction = beforeForwardAction
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let rect = CGRect(origin: .zero, size: frame.size)
        guard rect.contains(point) else { return nil }

        beforeForwardAction()
        return forwardView.hitTest(point, with: event)
    }
}

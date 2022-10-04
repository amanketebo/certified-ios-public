import SpriteKit

class PeekingCharacterSKView: SKView {

    // MARK: - Handling Touch Events

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let peekingCharacterScene = scene as? PeekingCharacterScene else {
            return nil
        }

        let point = convert(point, to: peekingCharacterScene)
        if peekingCharacterScene.shouldHandleTouchEvent(point: point, with: event) {
            return self
        } else {
            return nil
        }
    }
}

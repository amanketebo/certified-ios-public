import UIKit
import AVFoundation

class FeedView: UIView {

    var playerLayer: AVPlayerLayer?

    var player: AVPlayer? {
        get {
            return playerLayer?.player
        }

        set {
            playerLayer?.player = newValue
        }
    }

    private let feedType: FeedType

    init(frame: CGRect = .zero, feedType: FeedType) {
        self.feedType = feedType
        super.init(frame: frame)

        switch feedType {
        case .live:
            // TODO: Set up live front facing camera feed layer
            break
        case .recorded:
            let playerLayer = AVPlayerLayer()
            playerLayer.videoGravity = .resizeAspect
            layer.addSublayer(playerLayer)
            self.playerLayer = playerLayer
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = CGRect(origin: .zero, size: bounds.size)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

import SpriteKit

class PeekingCharacterScene: SKScene {

    // MARK: - Nested Types

    enum Character: String {
        case drake

        /// The offset to apply to make sure certain features of the character are shown when peek. For example, the
        /// drake character has a certain offset to make sure his face from the nose up is seen when peeking.
        var offset: CGFloat {
            switch self {
            case .drake:
                return 20
            }
        }

        var nodeSize: CGSize {
            switch self {
            case .drake:
                return CGSize(width: 125, height: 150)
            }
        }
    }

    enum PeekArea: Int, CaseIterable {
        case top
        case left
        case right
        case bottom

        var zRotation: CGFloat {
            switch self {
            case .top:
                return CGFloat.pi
            case .left:
                return 3 * CGFloat.pi / 2
            case .right:
                return CGFloat.pi / 2
            case .bottom:
                return 0
            }
        }
    }

    struct PeekData {
        let peekArea: PeekArea
        let peekPosition: CGPoint
        let hiddenPosition: CGPoint

        let numberOfTimesToPeek: Int
        var currentPeekIteration: Int

        let hiddenToPeekDuration: TimeInterval = 2
        let staringDuration: TimeInterval = 2
        let peekToHiddenDuration: TimeInterval = 2
    }

    // MARK: - Properties

    private let character: Character
    private let characterNode: SKSpriteNode
    private var previousPeekData: PeekData?
    private(set) var isPeekingAndHidingActive = false

    private var randomPeekArea: PeekArea? {
        guard let previousPeekArea = previousPeekData?.peekArea else {
            return PeekArea.allCases.randomElement()
        }

       return PeekArea.allCases.filter({ $0 != previousPeekArea }).randomElement()
    }

    // MARK: - Init

    init(character: Character, size: CGSize) {
        self.character = character
        self.characterNode = SKSpriteNode(imageNamed: character.rawValue)
        super.init(size: size)
        setUpScene()
        setUpCharacterNode()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        addChild(characterNode)
    }

    // MARK: - Set Up

    private func setUpScene() {
        backgroundColor = .clear
    }

    private func setUpCharacterNode() {
        let peekData = makePeekData(for: .left, currentPeekIteration: 0, numberOfTimesToPeek: 0)
        characterNode.size = character.nodeSize
        characterNode.position = peekData.hiddenPosition
        characterNode.zRotation = peekData.peekArea.zRotation
    }

    // MARK: - Peeking and Hiding

    func repeatedlyPeek(numberOfTimes: Int) {
        guard let previousPeekData = previousPeekData else {
            // No previous peek data meaning it's the first iteration of peeking.
            startPeeking(currentPeekIteration: 1, numberOfTimes: numberOfTimes)
            return
        }

        // Found previous peek data meaning we'll try to continue peeking if the peek limit has not been reached.
        let hasReachedPeekLimit = previousPeekData.currentPeekIteration + 1 > numberOfTimes
        if hasReachedPeekLimit {
            isPeekingAndHidingActive = false
            self.previousPeekData = nil
        } else {
            startPeeking(currentPeekIteration: previousPeekData.currentPeekIteration + 1, numberOfTimes: numberOfTimes)
        }
    }

    func startPeeking(currentPeekIteration: Int, numberOfTimes: Int) {
        let peekArea = randomPeekArea ?? .left
        let peekData = makePeekData(for: peekArea, currentPeekIteration: currentPeekIteration, numberOfTimesToPeek: numberOfTimes)
        previousPeekData = peekData
        isPeekingAndHidingActive = true
        peekCharacter(with: peekData) { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + peekData.staringDuration) {
                self?.hideCharacter(with: peekData) {
                    self?.repeatedlyPeek(numberOfTimes: numberOfTimes)
                }
            }
        }
    }

    private func peekCharacter(with peekData: PeekData, completion: (() -> Void)? = nil) {
        characterNode.zRotation = peekData.peekArea.zRotation
        characterNode.position = peekData.hiddenPosition
        let peekAction = SKAction.move(to: peekData.peekPosition, duration: peekData.hiddenToPeekDuration)
        peekAction.timingMode = .easeOut
        characterNode.run(peekAction) { completion?() }
    }

    private func hideCharacter(with peekData: PeekData, completion: (() -> Void)? = nil) {
        let hideAction = SKAction.move(to: peekData.hiddenPosition, duration: peekData.peekToHiddenDuration)
        hideAction.timingMode = .easeIn
        characterNode.run(hideAction) { completion?() }
    }

    func endPeekingIfNeeded() {
        guard isPeekingAndHidingActive else { return }
        removeAllActions()
        let peekData = makePeekData(for: .left, currentPeekIteration: 0, numberOfTimesToPeek: 0)
        characterNode.size = character.nodeSize
        characterNode.position = peekData.hiddenPosition
        characterNode.zRotation = peekData.peekArea.zRotation
    }
    

    // MARK: - Handling Tapping on Character

    func shouldHandleTouchEvent(point: CGPoint, with event: UIEvent?) -> Bool {
        if isPeekingAndHidingActive {
            return characterNode.contains(point)
        } else {
            return false
        }
    }

    // MARK: - Helpers

    private func makePeekData(for peekArea: PeekArea, currentPeekIteration: Int, numberOfTimesToPeek: Int) -> PeekData {
        let sceneWidth = size.width
        let sceneHeight = size.height
        let randomXPosition = CGFloat(Int.random(in: 0...Int(sceneWidth)))
        let randomYPosition = CGFloat(Int.random(in: 0...Int(sceneHeight)))

        switch peekArea {
        case .top:
            let xPosition = topBottomXPosition(xPositionCandidate: randomXPosition)
            return PeekData(
                peekArea: peekArea,
                peekPosition: CGPoint(x: xPosition, y: sceneHeight - character.offset),
                hiddenPosition: CGPoint(x: xPosition, y: sceneHeight + characterNode.size.height),
                numberOfTimesToPeek: numberOfTimesToPeek,
                currentPeekIteration: currentPeekIteration
            )
        case .left:
            let yPosition = leftRightYPosition(yPositionCandidate: randomYPosition)
            return PeekData(
                peekArea: peekArea,
                peekPosition: CGPoint(x: character.offset, y: yPosition),
                hiddenPosition: CGPoint(x: -characterNode.size.height, y: yPosition),
                numberOfTimesToPeek: numberOfTimesToPeek,
                currentPeekIteration: currentPeekIteration
            )
        case .right:
            let yPosition = leftRightYPosition(yPositionCandidate: randomYPosition)
            return PeekData(
                peekArea: peekArea,
                peekPosition: CGPoint(x: size.width - character.offset, y: yPosition),
                hiddenPosition: CGPoint(x: size.width + characterNode.size.height / 2, y: yPosition),
                numberOfTimesToPeek: numberOfTimesToPeek,
                currentPeekIteration: currentPeekIteration
            )
        case .bottom:
            let xPosition = topBottomXPosition(xPositionCandidate: randomXPosition)
            return PeekData(
                peekArea: peekArea,
                peekPosition: CGPoint(x: xPosition, y: character.offset),
                hiddenPosition: CGPoint(x: xPosition, y: -characterNode.size.height / 2),
                numberOfTimesToPeek: numberOfTimesToPeek,
                currentPeekIteration: currentPeekIteration
            )
        }
    }

    /// Clamps y position to make sure it doesn't get too close the top and bottom of the screen.
    private func leftRightYPosition(yPositionCandidate: CGFloat) -> CGFloat  {
        let minimumYPosition = characterNode.size.width / 2
        let maximumYPosition = size.height - (characterNode.size.width / 2)

        if yPositionCandidate < minimumYPosition {
            return minimumYPosition
        } else if yPositionCandidate > maximumYPosition {
            return maximumYPosition
        } else {
            return yPositionCandidate
        }
    }

    /// Clamps x position to make sure it only shows up on two x positions. One to the left of center and another to the
    /// right, that way it avoids the notch and home indicator on devices.
    private func topBottomXPosition(xPositionCandidate: CGFloat) -> CGFloat  {
        if xPositionCandidate <= (size.width / 2) {
            return size.width * 0.15
        } else {
            return size.width * 0.85
        }
    }
}

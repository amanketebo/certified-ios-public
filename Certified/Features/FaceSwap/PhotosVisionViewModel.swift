import UIKit
import Vision
import DelaunaySwift

class PhotosVisionViewModel {

    // MARK: - Properties

    var currentImage: UIImage {
        return images[currentImageIndex % images.count]
    }
    var shouldShowSimulatorAlert: Bool {
        #if targetEnvironment(simulator)
            return hasShownSimulatorAlert == false
        #else
            return false
        #endif
    }
    let delaunayAlgorithm = Delaunay()

    private let images: [UIImage] = [
        UIImage(named: "drake-covers/scorpion"),
        UIImage(named: "drake-covers/more-life"),
        UIImage(named: "drake-covers/nothing-was-the-same"),
        UIImage(named: "drake-covers/take-care")
    ].compactMap { $0 }
    private var currentImageIndex = 0
    private var hasShownSimulatorAlert = false

    // MARK: - Methods
    
    func nextImage() {
        currentImageIndex += 1
    }

    func showSimulatorAlertIfNeeded(on viewController: UIViewController) {
        guard shouldShowSimulatorAlert else { return }
        let alert = UIAlertController(
            title: "Remember",
            message: "Displaying face landmarks does not work on simulators. You'll see a face rectangle instead.",
            preferredStyle: .alert
        )
        let okayAction = UIAlertAction(title: "OK", style: .default)

        alert.addAction(okayAction)
        viewController.present(alert, animated: true)
        hasShownSimulatorAlert = true
    }

    // MARK: - Rect for Layers

    /// Returns the rect of a layer to place on top of an image view while taking into account that the image view is
    /// using the scale fit aspect ratio.
    /// - Parameters:
    ///   - image: CGImage for determining width and height of actual image
    ///   - imageViewBounds: Size of image view that will hold the image
    /// - Returns: Rect of layer to place on top of an image view.
    func entireImageLayerRect(for cgImage: CGImage, imageViewBounds: CGRect) -> CGRect {
        let imageAspectRatio = CGFloat(cgImage.width / cgImage.height)
        let imageViewWidth = imageViewBounds.width
        let imageViewHeight = imageViewBounds.height
        let imageViewAspectRatio = imageViewWidth / imageViewHeight

        let imageLayerSize: CGSize
        if imageAspectRatio > imageViewAspectRatio {
            imageLayerSize = CGSize(width: imageViewWidth, height: imageViewWidth / imageAspectRatio)
        } else {
            imageLayerSize = CGSize(width: imageViewHeight * imageAspectRatio, height: imageViewHeight)
        }

        let xPosition = (imageViewWidth - imageLayerSize.width) / 2
        let yPosition = (imageViewHeight - imageLayerSize.height) / 2

        return CGRect(origin: CGPoint(x: xPosition, y: yPosition), size: imageLayerSize)
    }


    /// Converts normalized bounding box rect to a non normalized bounding box for the image layer bounds.
    /// - Parameters:
    ///   - normalizedBoundingBox: Bounding box of face from Vision's framework
    ///   - imageLayerBounds: Bounds of the image layer.
    /// - Returns: Non normalized rect of the face bounding box.
    func faceRect(normalizedBoundingBox: CGRect, imageLayerBounds: CGRect) -> CGRect {
        let imageWidth = imageLayerBounds.width
        let imageHeight = imageLayerBounds.height
        var updatedBoundingBox = normalizedBoundingBox

        updatedBoundingBox.origin.x *= imageWidth
        updatedBoundingBox.origin.y = (1 - updatedBoundingBox.origin.y) * imageLayerBounds.height
        updatedBoundingBox.size.width *= imageWidth
        updatedBoundingBox.size.height *= imageHeight

        return updatedBoundingBox
    }

    // MARK: - Points for Drawing Landmarks

    func points(for landmarks: VNFaceLandmarks2D?) -> [CGPoint] {
        guard let landmarks = landmarks else { return [] }
        let landmarksToDraw = [
            landmarks.faceContour,
            landmarks.leftEyebrow,
            landmarks.rightEyebrow,
            landmarks.leftEye,
            landmarks.rightEye,
            landmarks.medianLine,
            landmarks.nose,
            landmarks.outerLips,
            landmarks.innerLips
        ]
        let landmarkPoints = landmarksToDraw.compactMap { $0?.normalizedPoints }.flatMap { $0 }
        let vertices = landmarkPoints.map { Vertex(x: $0.x, y: $0.y) }
        let triangles = delaunayAlgorithm.triangulate(vertices)
        let trianglesInPoints = triangles.map {
            return [
                CGPoint(x: $0.vertex1.x, y: $0.vertex1.y),
                CGPoint(x: $0.vertex2.x, y: $0.vertex2.y),
                CGPoint(x: $0.vertex3.x, y: $0.vertex3.y)
            ]
        }
        return trianglesInPoints.flatMap { $0 }
    }
}

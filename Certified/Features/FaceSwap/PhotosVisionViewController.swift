import UIKit
import Vision
import DelaunaySwift

class PhotosVisionViewController: UIViewController {

    // MARK: - Properties

    let model = PhotosVisionViewModel()

    // MARK: Views

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: nil)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.addTarget(self, action: #selector(tappedNextButton), for: .touchUpInside)
        return button
    }()

    // MARK: Layers

    private let imageOverlayLayer = CALayer()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpImageView()
        setUpNextButton()
        setUpImageOverlayLayer()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let image = model.currentImage
        imageView.image = image
        detectFaces(on: image)
        model.showSimulatorAlertIfNeeded(on: self)
    }

    // MARK: - Set Up

    private func setUpImageView() {
        view.addConstrained(imageView, left: 0, top: nil, right: 0, bottom: nil)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }

    private func setUpNextButton() {
        view.addConstrained(nextButton, left: nil, top: nil, right: nil, bottom: 0)
        NSLayoutConstraint.activate([
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func setUpImageOverlayLayer() {
        imageView.layer.addSublayer(imageOverlayLayer)
    }

    // MARK: - Detecting Faces

    private func detectFaces(on image: UIImage) {
        guard let cgImage = image.cgImage else { return }

        CATransaction.begin()
        imageOverlayLayer.frame = model.entireImageLayerRect(for: cgImage, imageViewBounds: imageView.bounds)
        CATransaction.commit()

        let faceLandmarksRequest = VNDetectFaceLandmarksRequest(completionHandler: handleFaceLandmarksRequest)
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, orientation: .up)
        DispatchQueue.global(qos: .userInitiated).async {
            try? requestHandler.perform([faceLandmarksRequest])
        }
    }


    private func handleFaceLandmarksRequest(request: VNRequest, error: Error?) {
        guard let faceObservations = request.results as? [VNFaceObservation] else { return }

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            for faceObservation in faceObservations {
            #if targetEnvironment(simulator)
                self.drawFaceRect(with: faceObservation, imageLayerBounds: self.imageOverlayLayer.bounds)
            #else
                self.drawFaceLandmarks(with: faceObservation, imageLayerBounds: self.imageOverlayLayer.bounds)
            #endif
            }
            self.nextButton.isEnabled = true
        }
    }

    private func drawFaceRect(with faceObservation: VNFaceObservation, imageLayerBounds: CGRect) {
        CATransaction.begin()
        let faceRect = model.faceRect(
            normalizedBoundingBox: faceObservation.boundingBox,
            imageLayerBounds: imageLayerBounds
        )
        let faceRectLayer = makeFaceRectLayer(rect: faceRect)
        imageOverlayLayer.addSublayer(faceRectLayer)
        CATransaction.commit()
    }

    private func drawFaceLandmarks(with faceObservation: VNFaceObservation, imageLayerBounds: CGRect) {
        let faceRect = model.faceRect(
            normalizedBoundingBox: faceObservation.boundingBox,
            imageLayerBounds: imageLayerBounds
        )
        let transform = CGAffineTransform(scaleX: faceRect.width, y: faceRect.height)
        let points = model.points(for: faceObservation.landmarks)

        CATransaction.begin()
        let path = CGMutablePath()
        path.addLines(between: points, transform: transform)
        path.closeSubpath()
        let landmarkLayer = makeFaceLandmarkLayer(rect: faceRect, path: path)
        imageOverlayLayer.addSublayer(landmarkLayer)
        CATransaction.commit()
    }

    private func makeFaceRectLayer(rect: CGRect) -> CAShapeLayer {
        let faceRectLayer = CAShapeLayer()
        faceRectLayer.anchorPoint = .zero
        faceRectLayer.frame = rect
        faceRectLayer.transform = CATransform3DMakeScale(1, -1, 1)
        faceRectLayer.backgroundColor = UIColor.blue.withAlphaComponent(0.5).cgColor
        return faceRectLayer
    }

    private func makeFaceLandmarkLayer(rect: CGRect, path: CGMutablePath) -> CAShapeLayer {
        let landmarkLayer = CAShapeLayer()
        landmarkLayer.masksToBounds = false
        landmarkLayer.lineWidth = 1
        landmarkLayer.strokeColor = UIColor.red.cgColor
        landmarkLayer.fillColor = nil
        landmarkLayer.path = path
        landmarkLayer.anchorPoint = .zero
        landmarkLayer.frame = rect
        landmarkLayer.transform = CATransform3DMakeScale(1, -1, 1)
        return landmarkLayer
    }

    // MARK: - Buttons

    @objc
    private func tappedNextButton() {
        nextButton.isEnabled = false
        goToNextImage()
    }

    private func goToNextImage() {
        imageOverlayLayer.sublayers?.removeAll()
        model.nextImage()
        let image = model.currentImage
        imageView.image = image
        detectFaces(on: image)
    }
}

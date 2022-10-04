import SwiftUI

final class SystemShareSheet: UIViewControllerRepresentable {

    let image: UIImage

    init(image: UIImage) {
        self.image = image
    }

    func makeUIViewController(context: Context) -> UIActivityViewController {
        return UIActivityViewController(activityItems: [image], applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) { }
}

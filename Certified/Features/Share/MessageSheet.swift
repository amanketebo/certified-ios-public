import SwiftUI
import MessageUI

class MessageSheetCoordinator: NSObject, MFMessageComposeViewControllerDelegate {
    let dismissCompletion: () -> Void

    init(dismissCompletion: @escaping () -> Void) {
        self.dismissCompletion = dismissCompletion
        super.init()
    }

    func messageComposeViewController( _ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result {
        case .sent:
            dismissCompletion()
        case .cancelled:
            dismissCompletion()
        case .failed:
            break
        @unknown default:
            break
        }
    }
}

final class MessageSheet: UIViewControllerRepresentable {

    let sharingPhoto: SharingPhoto
    let dismissCompletion: () -> Void

    init(sharingPhoto: SharingPhoto, dismissCompletion: @escaping () -> Void) {
        self.sharingPhoto = sharingPhoto
        self.dismissCompletion = dismissCompletion
    }

    func makeCoordinator() -> MessageSheetCoordinator {
        MessageSheetCoordinator(dismissCompletion: dismissCompletion)
    }

    func makeUIViewController(context: Context) -> MFMessageComposeViewController {
        let messageComposeViewController = MFMessageComposeViewController()
        messageComposeViewController.addAttachmentData(
            sharingPhoto.data,
            typeIdentifier: sharingPhoto.typeIdentifier,
            filename: sharingPhoto.filename
        )
        messageComposeViewController.messageComposeDelegate = context.coordinator
        return messageComposeViewController
    }

    func updateUIViewController(_ uiViewController: MFMessageComposeViewController, context: Context) { }
}

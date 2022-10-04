import SwiftUI
import MessageUI
import Photos

enum SendMessageError: Error {
    case deviceCannotSendText
    case failedToCreateImageData
}

struct SharingPhoto {

    let data: Data
    let uiImage: UIImage
    let typeIdentifier: String
    let filename: String
}

class ShareShareSectionModel: ObservableObject {
    
    let title = "Share"
    let shareViewProxy: GeometryProxy
    let leadingTrailingPadding: CGFloat
    let albumCoverViewModel: AlbumCoverViewModel
    let shareApps: [ShareApp]
    let shareAppViewImageWidthHeight: CGFloat
    let spaceBetweenShareAppViews: CGFloat = 20
    var sharingPhoto = SharingPhoto(data: Data(), uiImage: UIImage(), typeIdentifier: "", filename: "")

    init(
        shareViewProxy: GeometryProxy,
        leadingTrailingPadding: CGFloat,
        albumCoverViewModel: AlbumCoverViewModel
    ) {
        self.shareViewProxy = shareViewProxy
        self.leadingTrailingPadding = leadingTrailingPadding
        self.albumCoverViewModel = albumCoverViewModel
        self.shareApps = [.photos, .messages, .other]

        // Set share app image width and height
        let totalLeadingTrailingPadding = leadingTrailingPadding * 2
        let totalSpaceBetweenShareAppViews = spaceBetweenShareAppViews * CGFloat(shareApps.count - 1)
        let availableSpace = shareViewProxy.size.width - totalSpaceBetweenShareAppViews - totalLeadingTrailingPadding
        shareAppViewImageWidthHeight = availableSpace / CGFloat(shareApps.count)
    }

    func tappedOn(
        shareAppViewModel: ShareAppViewModel,
        savedPhotoCompletion: ((_ shouldShowPermissionsError: Bool) -> Void)? = nil,
        openMessageSheetCompletion: ((Result<Data, SendMessageError>) -> Void)? = nil,
        openShareSheetCompletion: ((UIImage) -> Void)? = nil
    ) {
        sharingPhoto = makeScreenshot(for: albumCoverViewModel)

        switch shareAppViewModel.shareApp {
        case .photos:
            shareToPhotos(sharingPhoto.uiImage, savedPhotoCompletion: savedPhotoCompletion)
        case .messages:
            guard MFMessageComposeViewController.canSendText() else {
                openMessageSheetCompletion?(.failure(.deviceCannotSendText))
                return
            }
            openMessageSheetCompletion?(.success(sharingPhoto.data))
        case .other:
            openShareSheetCompletion?(sharingPhoto.uiImage)
        }
    }

    private func shareToPhotos(
        _ image: UIImage,
        savedPhotoCompletion: ((_ shouldShowPermissionsError: Bool) -> Void)? = nil
    ) {
        let photoLibraryAuthorization = PHPhotoLibrary.authorizationStatus(for: .addOnly)

        switch photoLibraryAuthorization {
        case .authorized, .notDetermined:
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            savedPhotoCompletion?(false)
        case .restricted, .denied, .limited:
            savedPhotoCompletion?(true)
        @unknown default:
            break
        }
    }

    private func makeScreenshot(for selectedAlbumCoverViewModel: AlbumCoverViewModel) -> SharingPhoto {
        let albumCoverView = AlbumCoverView(viewModel: selectedAlbumCoverViewModel)
            .ignoresSafeArea(.all, edges: .all)
            .environmentObject(ThemeManager.shared)
        let hostingController = UIHostingController(rootView: albumCoverView)
        let hostingControllerView = hostingController.view
        let targetSize = hostingController.view.intrinsicContentSize
        let renderer = UIGraphicsImageRenderer(size: targetSize)

        hostingControllerView?.bounds = CGRect(origin: .zero, size: targetSize)
        hostingControllerView?.backgroundColor = .clear

        let image = renderer.image { _ in
            hostingControllerView?.drawHierarchy(in: hostingController.view.bounds, afterScreenUpdates: true)
        }
        if let imageData = image.jpegData(compressionQuality: 1) {
            return SharingPhoto(data: imageData, uiImage: image, typeIdentifier: "image/jpeg", filename: "album-cover.jpeg")
        } else {
            // TODO: Handle error
            return SharingPhoto(data: Data(), uiImage: image, typeIdentifier: "image/jpeg", filename: "album-cover.jpeg")
        }
    }

    func openPhotosApp() {
        let photoAppURL = URL(string: "photos-redirect://")

        if let photoAppURL = photoAppURL {
            UIApplication.shared.open(photoAppURL)
        } else {
            // TODO: Handle error
        }
    }

    func openSettingsApp() {
        let settingsURL = URL(string: UIApplication.openSettingsURLString)

        if let settingsURL = settingsURL {
            UIApplication.shared.open(settingsURL)
        } else {
            // TODO: Handle error
        }
    }
}

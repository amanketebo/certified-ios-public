import SwiftUI
import UIKit

struct ShareShareSectionView: View {

    // MARK: - Properties

    // MARK: Models

    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var model: ShareShareSectionModel

    // MARK: Images

    @State var shareSheetImage = UIImage()
    @State var messageSheetImageData = Data()

    // MARK: Alerts

    @State var isSavedPhotoAlertPresented = false
    @State var isShareSheetPresented = false
    @State var isMessageSheetPresented = false
    @State var isPermissionsErrorAlertPresented = false
    @State var isDeviceCannotSendTextAlertPresented = false
    @State var isGenericErrorPresented = false

    var body: some View {
        ShareSectionTitleView(title: model.title)
            .padding([.leading, .trailing], model.leadingTrailingPadding)
        Spacer(minLength: 16)
        HStack(spacing: model.spaceBetweenShareAppViews) {
            ForEach(model.shareApps, id: \.self) { shareApp in
                let shareAppViewModel = ShareAppViewModel(
                    shareApp: shareApp,
                    imageWidthHeight: model.shareAppViewImageWidthHeight
                )
                Button {
                    self.model.tappedOn(
                        shareAppViewModel: shareAppViewModel,
                        savedPhotoCompletion: { shouldShowPermissionsError in
                            if shouldShowPermissionsError {
                                isPermissionsErrorAlertPresented = true
                            } else {
                                isSavedPhotoAlertPresented = true
                            }
                        },
                        openMessageSheetCompletion: { result in
                            switch result {
                            case .success(let imageData):
                                messageSheetImageData = imageData
                                isMessageSheetPresented = true
                            case .failure(.deviceCannotSendText):
                                isDeviceCannotSendTextAlertPresented = true
                            case .failure(.failedToCreateImageData):
                                isGenericErrorPresented = true
                            }
                        },
                        openShareSheetCompletion: { screenshot in
                            shareSheetImage = screenshot
                            isShareSheetPresented = true
                        }
                    )
                } label: {
                    ShareAppView(model: shareAppViewModel)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .alert("Saved to Photos!", isPresented: $isSavedPhotoAlertPresented, actions: {
            Button("Open Photos") { model.openPhotosApp() }
            Button("Done") { }
        })
        .alert("Cannot Send Text", isPresented: $isDeviceCannotSendTextAlertPresented, actions: {
            Button("OK") { }
        }, message: {
            Text("Device cannot send text messages. Try again on another device.")
        })
        .alert("Check Permissions", isPresented: $isPermissionsErrorAlertPresented, actions: {
            Button("Open Settings") { model.openSettingsApp() }
            Button("OK") { }
        }, message: {
            Text("Looks like you haven't given permission for this app to add photos to your library.")
        })
        .alert("Oops!", isPresented: $isGenericErrorPresented, actions: {
            Button("OK") { }
        }, message: {
            Text("Something went wrong. Try again later.")
        })
        .sheet(isPresented: $isMessageSheetPresented, content: {
            MessageSheet(sharingPhoto: model.sharingPhoto) { isMessageSheetPresented = false }
        })
        .sheet(isPresented: $isShareSheetPresented, content: {
            SystemShareSheet(image: model.sharingPhoto.uiImage)
        })
    }
}

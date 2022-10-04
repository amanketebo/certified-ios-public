import SwiftUI

enum ShareApp: Identifiable {
    case photos
    case messages
    case other

    var id: ShareApp {
        return self
    }
}

struct ShareAppViewModel {
    let shareApp: ShareApp
    let image: Image
    let title: Text
    let imageWidthHeight: CGFloat

    init(shareApp: ShareApp, imageWidthHeight: CGFloat) {
        self.shareApp = shareApp
        self.imageWidthHeight = imageWidthHeight
        switch shareApp {
        case .photos:
            self.image = Image("photos-app")
            self.title = Text("Photos")
        case .messages:
            self.image = Image("messages-app")
            self.title = Text("Messages")
        case .other:
            self.image = Image(systemName: "questionmark")
            self.title = Text("Other")
        }
    }
}

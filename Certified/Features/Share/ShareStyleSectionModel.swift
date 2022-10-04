import SwiftUI

struct StyleSettings: Codable {
    var isRoundOn: Bool
    var isBorderOn: Bool
}

class ShareStyleSectionModel: ObservableObject {

    // MARK: - Properties
    
    let title = "Style"
    let shareViewProxy: GeometryProxy
    let albumCoverViewModel: AlbumCoverViewModel
    let userDefaults: UserDefaults

    @Published var styleSettings = StyleSettings(isRoundOn: true, isBorderOn: true)

    var leadingTrailingPadding: CGFloat {
        CGFloat(shareViewProxy.size.width - albumCoverViewModel.exactViewWidth) / 2
    }

    var spaceBetweenCovers: CGFloat {
        leadingTrailingPadding * 2
    }

    // MARK: - Init

    init(shareViewProxy: GeometryProxy, albumCoverViewModel: AlbumCoverViewModel, userDefaults: UserDefaults = .standard) {
        self.shareViewProxy = shareViewProxy
        self.albumCoverViewModel = albumCoverViewModel
        self.userDefaults = userDefaults
        fetchStyleSettings()
    }

    // MARK: - Style Settings

    func updateIsBorderOn(_ newValue: Bool) {
        albumCoverViewModel.updateIsBorderOn(newValue)
        saveStyleSettings()
    }

    func updateIsRoundOn(_ newValue: Bool) {
        albumCoverViewModel.updateIsRoundOn(newValue)
        saveStyleSettings()
    }

    func fetchStyleSettings() {
        guard let object = userDefaults.object(forKey: UserDefaultsKeys.styleSettings.rawValue) as? Data,
              let styleSettings = try? JSONDecoder().decode(StyleSettings.self, from: object)else {
            // TODO: Handle error
            return
        }

        self.styleSettings = styleSettings
    }

    private func saveStyleSettings() {
        guard let encodedStyleSettings = try? JSONEncoder().encode(styleSettings) else {
            // TODO: Handle error
            return
        }

        userDefaults.set(encodedStyleSettings, forKey: UserDefaultsKeys.styleSettings.rawValue)
    }
}

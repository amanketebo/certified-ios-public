import Foundation
import MusicKit
import MediaPlayer

class AppleMusicManager {

    // MARK: - Nested Types

    enum RequestAuthError: Error {
        case authorizedButRestricted
        case denied
        case restricted
    }

    enum ResourceRequestError: Error {
        case emptyResponse
    }

    // MARK: - Request Auth

    func requestAuthorization() async throws {
        let status = await MusicAuthorization.request()

        switch status {
        case .authorized:
            let canPlayMusic = try await MusicSubscription.current.canPlayCatalogContent
            guard !canPlayMusic else { return }
            throw RequestAuthError.authorizedButRestricted
        case .denied:
            throw RequestAuthError.denied
        case .notDetermined:
            break
        case .restricted:
            throw RequestAuthError.restricted
        @unknown default:
            assertionFailure("Programmer error: Unknown result type.")
        }
    }

    // MARK: - Playback

    func fetchKnifeTalkSong() async throws -> MusicItemCollection<Song>.Element {
        let knifeTalkMusicItemID = MusicItemID("1584281787")
        let songRequest = MusicCatalogResourceRequest<Song>(matching: \.id, equalTo: knifeTalkMusicItemID)
        let songResponse = try await songRequest.response()

        guard let song = songResponse.items.first else {
            throw ResourceRequestError.emptyResponse
        }

        return song
    }
}

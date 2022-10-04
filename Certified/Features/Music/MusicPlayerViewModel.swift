import UIKit
import SwiftUI
import MusicKit
import Combine

struct ErrorAlert {

    static let genericErrorAlert = ErrorAlert(title: "Oops", message: "Something went wrong. Please try again later.")

    let title: String
    let message: String
}

class MusicPlayerViewModel: ObservableObject {

    // MARK: - Properties

    @Published var artwork: UIImage?
    @Published var isErrorPresented = false
    @Published var isFetchingSong = false
    var errorAlert = ErrorAlert.genericErrorAlert

    var imageForPlayerState: Image {
        switch playerState.playbackStatus {
        case .paused, .stopped, .interrupted, .seekingBackward, .seekingForward:
            return Image(systemName: "play.fill")
        case .playing:
            return Image(systemName: "pause.fill")
        @unknown default:
            return Image(systemName: "play.fill")
        }
    }

    @Published private var playerState = ApplicationMusicPlayer.shared.state
    private let appleMusicManager = AppleMusicManager()
    private let applicationPlayer = ApplicationMusicPlayer.shared
    private let urlSession = URLSession.shared
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Init

    init() {
        // A workaround for having an observable object nested in another observable object.
        playerState.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }.store(in: &subscriptions)
    }

    // MARK: - Playback

    func handleButtonTap() {
        switch playerState.playbackStatus {
        case .paused, .stopped, .interrupted, .seekingBackward, .seekingForward:
            handlePlayingKnifeTalk()
        case .playing:
            pauseKnifeTalk()
        @unknown default:
            assertionFailure("Programmer error: Unknown playback status.")
        }
    }

    func handlePlayingKnifeTalk() {
        switch MusicAuthorization.currentStatus {
        case .authorized:
            isFetchingSong = true
            playKnifeTalk()
        case .denied:
            show(errorAlert(for: .denied))
        case .notDetermined:
            Task {
                do {
                    try await appleMusicManager.requestAuthorization()
                } catch {
                    await MainActor.run { handleError(error) }
                }
            }
        case .restricted:
            show(errorAlert(for: .restricted))
        @unknown default:
            assertionFailure()
            break
        }
    }

     func playKnifeTalk() {
        Task {
            do {
                let knifeTalkSong = try await appleMusicManager.fetchKnifeTalkSong()
                applicationPlayer.queue = ApplicationMusicPlayer.Queue(arrayLiteral: knifeTalkSong)
                try await applicationPlayer.play()
                await MainActor.run { isFetchingSong = false }
                guard let knifeTalkArtworkURL = knifeTalkSong.artwork?.url(width: 300, height: 300) else {
                    // Keep showing placeholder cover.
                    return
                }
                let (data, _) = try await urlSession.data(from: knifeTalkArtworkURL)
                await MainActor.run { self.artwork = UIImage(data: data) }
            } catch {
                await MainActor.run { handleError(error) }
            }
        }
    }

    private func pauseKnifeTalk() {
        applicationPlayer.pause()
    }

    // MARK: - Error Alerts

    private func handleError(_ error: Error) {
        isFetchingSong = false
        if let requestAuthError = error as? AppleMusicManager.RequestAuthError {
            show(errorAlert(for: requestAuthError))
        } else if let resourceRequestError = error as? AppleMusicManager.ResourceRequestError {
            show(errorAlert(for: resourceRequestError))
        } else {
            show(.genericErrorAlert)
        }
    }

    private func show(_ errorAlert: ErrorAlert) {
        self.errorAlert = errorAlert
        isErrorPresented = true
    }

    // MARK: - Helpers

    private func errorAlert(for requestAuthError: AppleMusicManager.RequestAuthError) -> ErrorAlert {
        switch requestAuthError {
        case .authorizedButRestricted:
            return ErrorAlert(title: "Restricted", message: "Your Apple Music account does not have access to Apple Music.")
        case .denied:
            return ErrorAlert(title: "Denied", message: "Update the app's permissions in the Settings app.")
        case .restricted:
            return ErrorAlert(title: "Restricted", message: "Your Apple Music account does not have access to Apple Music.")
        }
    }

    private func errorAlert(for resourceRequestError: AppleMusicManager.ResourceRequestError) -> ErrorAlert {
        switch resourceRequestError {
        case .emptyResponse:
            return .genericErrorAlert
        }
    }
}

import SwiftUI
import ISEmojiView

struct EmojiTextField: UIViewRepresentable {

    // MARK: - Nested Types

    class EmojiTextFieldCoordinator: NSObject, UITextFieldDelegate {

        let textField: UITextField
        let viewModel: AlbumCoverViewModel
        let albumCoverEmojiInfo: AlbumCoverEmojiInfo

        init(textField: UITextField, viewModel: AlbumCoverViewModel, albumCoverEmojiInfo: AlbumCoverEmojiInfo) {
            self.textField = textField
            self.viewModel = viewModel
            self.albumCoverEmojiInfo = albumCoverEmojiInfo
            super.init()
            textField.delegate = self
        }

        func textFieldDidBeginEditing(_ textField: UITextField) {
            viewModel.turnOnEditMode(for: albumCoverEmojiInfo)
        }

        func textFieldDidEndEditing(_ textField: UITextField) {
            viewModel.turnOffEditMode(for: albumCoverEmojiInfo)
        }
    }
    
    // MARK: - Properties
    
    var viewModel: AlbumCoverViewModel
    var albumCoverEmojiInfo: AlbumCoverEmojiInfo
    let textField = UITextField()
    
    // MARK: - Init
    
    init(viewModel: AlbumCoverViewModel, albumCoverEmojiInfo: AlbumCoverEmojiInfo) {
        self.viewModel = viewModel
        self.albumCoverEmojiInfo = albumCoverEmojiInfo
    }
    
    // MARK: - Make
    
    func makeUIView(context: Context) -> UITextField {
        textField.font = viewModel.albumCoverFont
        textField.text = "🤰🏽"
        textField.inputView = AlbumCoverViewModel.emojiKeyboard
        return textField
    }

    func makeCoordinator() -> EmojiTextFieldCoordinator {
        EmojiTextFieldCoordinator(textField: textField, viewModel: viewModel, albumCoverEmojiInfo: albumCoverEmojiInfo)
    }
    
    // MARK: - Update
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = viewModel.emoji(for: albumCoverEmojiInfo)

        let isMatchingAlbumCover = context.coordinator.viewModel.currentAlbumCoverEmojiInfo == albumCoverEmojiInfo
        guard isMatchingAlbumCover else { return }

        DispatchQueue.main.async {
            uiView.becomeFirstResponder()
        }
    }
}

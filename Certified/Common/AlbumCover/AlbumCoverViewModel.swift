import Foundation
import Combine
import SwiftUI
import ISEmojiView

protocol AlbumCoverViewModelDelegate: AnyObject {
    func didUpdateEditMode(_ editMode: EditMode)
    func didUpdateEmojis(_ isAllKnifeEmojis: Bool)
}

class AlbumCoverViewModel: ObservableObject, EmojiViewDelegate, Identifiable {
    
    // MARK: Nested Type
    
    enum Context {
        case create(superviewWidth: CGFloat)
        case onboarding(superviewWidth: CGFloat)
        case share(superviewWidth: CGFloat, isRoundOn: Bool, isBorderOn: Bool)
        case collection(columnItemWidth: CGFloat)
    }
    
    // MARK: - Properties

    static let emojiKeyboard: EmojiView = {
        let view = EmojiView(keyboardSettings: .init(bottomType: .categories))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    @Published var rows: [AlbumCoverRow] = [
        AlbumCoverRow(rowNumber: 0),
        AlbumCoverRow(rowNumber: 1),
        AlbumCoverRow(rowNumber: 2)
    ]
    @Published private(set) var context: Context

    weak var delegate: AlbumCoverViewModelDelegate?

    private let database: Database?
    private(set) var currentAlbumCoverEmojiInfo: AlbumCoverEmojiInfo?

    // MARK: Identifiable

    let id = UUID()
    
    // MARK: Computed
    
    var isEditable: Bool {
        switch context {
        case .create:
            return true
        case .collection, .onboarding, .share:
            return false
        }
    }
    
    var isEditModeOnForAnyEmoji: Bool {
        return rows.contains { row in
            row.emojis.contains { emoji in
                emoji.editMode == .on
            }
        }
    }
    
    var albumCoverPadding: EdgeInsets {
        switch context {
        case .create, .onboarding, .share:
            return EdgeInsets(top: 21, leading: 12, bottom: 21, trailing: 12)
        case .collection:
            return EdgeInsets(top: 16, leading: 4, bottom: 16, trailing: 4)
        }
    }
    
    var albumCoverVerticalSpacing: CGFloat {
        switch context {
        case .create, .onboarding, .share:
            return 15
        case .collection:
            return 10
        }
    }
    
    var albumCoverFont: UIFont {
        switch context {
        case .create, .onboarding, .share:
            return UIFont.systemFont(ofSize: exactViewWidth * 0.23)
        case .collection(let columnItemWidth):
            return UIFont.systemFont(ofSize: columnItemWidth * 0.23)
        }
    }
    
    var shouldAddShadow: Bool {
        switch context {
        case .create, .onboarding:
            return true
        case .collection, .share:
            return false
        }
    }
    
    /// Using a text field on the covers screens causes scrolling performance issues. In order to avoid this, use this property to decide whether to use
    /// a text field or a text view.
    var shouldUseTextField: Bool {
        switch context {
        case .create, .onboarding:
            return true
        case .collection, .share:
            return false
        }
    }

    var exactViewWidthWithoutPadding: CGFloat {
        guard !shouldUseMaxWidthAndHeight else {
            return 0
        }

        switch context {
        case .create(let superviewWidth), .onboarding(let superviewWidth), .share(let superviewWidth, _, _):
            let totalHorizontalPadding = albumCoverPadding.leading - albumCoverPadding.trailing
            let totalHorizontalInset = leadingTrailingInset * 2
            return superviewWidth - totalHorizontalPadding - totalHorizontalInset
        case .collection:
            return 0
        }
    }

    var exactViewWidth: CGFloat {
        guard !shouldUseMaxWidthAndHeight else {
            return 0
        }

        switch context {
        case .create, .onboarding, .share:
            return exactViewWidthWithoutPadding + albumCoverPadding.leading + albumCoverPadding.trailing
        case .collection:
            return 0
        }
    }

    var exactViewHeightWithoutPadding: CGFloat {
        guard !shouldUseMaxWidthAndHeight || exactViewWidthWithoutPadding >= 0 else {
            return 0
        }

        return exactViewWidthWithoutPadding * 1.04
    }

    var shouldUseMaxWidthAndHeight: Bool {
        switch context {
        case .create, .onboarding, .share:
            return false
        case .collection:
            return true
        }
    }

    var isAllKnifeEmojis: Bool {
        rows.allSatisfy { $0.emojis.allSatisfy { $0.emoji == "🔪" } }
    }

    var shouldRoundCover: Bool {
        switch context {
        case .create, .onboarding, .collection:
            return true
        case .share(_, let isRoundOn, _):
            return isRoundOn
        }
    }

    var cornerRadius: CGFloat {
        let cornerRadius: CGFloat = 16

        switch context {
        case .create, .onboarding, .collection:
            return cornerRadius
        case .share(_, let isRoundOn, _):
            return isRoundOn ? cornerRadius : 0
        }
    }

    var shouldShowBorder: Bool {
        switch context {
        case .create, .onboarding, .collection:
            return true
        case .share(_, _, let isBorderOn):
            return isBorderOn
        }
    }

    // MARK: - Constants

    let borderWidth: CGFloat = 2
    let leadingTrailingInset: CGFloat = 32
    
    // MARK: - Init
    
    init(context: Context, database: Database? = nil, delegate: AlbumCoverViewModelDelegate? = nil) {
        self.context = context
        self.database = database
        self.delegate = delegate
        commonInit(context: context)
    }

    init(context: Context, albumCoverRows: [[String]]) {
        self.context = context
        self.database = nil
        self.delegate = nil
        commonInit(context: context)
        
        var rows: [AlbumCoverRow] = []
        for (rowNumber, emojis) in albumCoverRows.enumerated() {
            rows.append(AlbumCoverRow(rowNumber: rowNumber, setEmojis: emojis))
        }
        self.rows = rows
    }

    init(context: Context, rows: [AlbumCoverRow]) {
        self.context = context
        self.database = nil
        self.delegate = nil
        commonInit(context: context)
        self.rows = rows
    }

    private func commonInit(context: Context) {
        switch context {
        case .create:
            AlbumCoverViewModel.emojiKeyboard.delegate = self
        case .collection, .onboarding, .share:
            break
        }
    }
    
    // MARK: - Edit Mode
    
    func turnOnEditMode(for albumCoverEmojiInfo: AlbumCoverEmojiInfo) {
        guard isEditable else { return }

        var updatedAlbumCoverEmojiInfo = albumCoverEmojiInfo
        updatedAlbumCoverEmojiInfo.editMode = .on
        currentAlbumCoverEmojiInfo = updatedAlbumCoverEmojiInfo
        rows[updatedAlbumCoverEmojiInfo.rowNumber].emojis[updatedAlbumCoverEmojiInfo.columnNumber] = updatedAlbumCoverEmojiInfo
        delegate?.didUpdateEditMode(.on)
    }
    
    func turnOffEditMode(for albumCoverEmojiInfo: AlbumCoverEmojiInfo) {
        guard isEditable else { return }
        
        rows[albumCoverEmojiInfo.rowNumber].emojis[albumCoverEmojiInfo.columnNumber].editMode = .off
    }
    
    func turnOffEditModeForAllEmojis() {
        guard isEditable else { return }
        
        updateAllEditModes(to: .off)
        currentAlbumCoverEmojiInfo = nil
        delegate?.didUpdateEditMode(.off)
        
        // When edit mode is turned off for all the emoji text fields, the text field which was in focus never
        // stops being the first responder which causes issues when tapping on the same text field in order to begin
        // editing again.
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    private func updateAllEditModes(to editMode: EditMode) {
        guard isEditable else { return }
        
        rows.forEach { row in
            row.emojis.forEach { emoji in
                rows[emoji.rowNumber].emojis[emoji.columnNumber].editMode = editMode
            }
        }
    }
    
    // MARK: - Emoji Appearance
    
    func emojiYShadowOffset(for albumCoverEmojiInfo: AlbumCoverEmojiInfo) -> CGFloat {
        let albumCoverEmoji = rows[albumCoverEmojiInfo.rowNumber].emojis[albumCoverEmojiInfo.columnNumber]
        switch albumCoverEmoji.editMode {
        case .on:
            return 15
        case .off:
            return 0
        }
    }
    
    func emojiRadiusShadow(for albumCoverEmojiInfo: AlbumCoverEmojiInfo) -> CGFloat {
        let albumCoverEmoji = rows[albumCoverEmojiInfo.rowNumber].emojis[albumCoverEmojiInfo.columnNumber]
        switch albumCoverEmoji.editMode {
        case .on:
            return 15
        case .off:
            return 0
        }
    }

    func emoji(for albumCoverEmojiInfo: AlbumCoverEmojiInfo) -> String {
        rows[albumCoverEmojiInfo.rowNumber].emojis[albumCoverEmojiInfo.columnNumber].emoji
    }
    
    // MARK: - Update Emojis
    
    func updateEmoji(_ emoji: String, for albumCoverEmojiInfo: AlbumCoverEmojiInfo) {
        rows[albumCoverEmojiInfo.rowNumber].emojis[albumCoverEmojiInfo.columnNumber].emoji = emoji
        delegate?.didUpdateEmojis(isAllKnifeEmojis)
    }

    // MARK: - Update Context

    func updateContext(newContext: Context) {
        context = newContext
    }

    func updateIsBorderOn(_ newValue: Bool) {
        switch context {
        case .create, .onboarding, .collection:
            break
        case .share(let superviewWidth, let isRoundOn, _):
            context = .share(superviewWidth: superviewWidth, isRoundOn: isRoundOn, isBorderOn: newValue)
        }
    }

    func updateIsRoundOn(_ newValue: Bool) {
        switch context {
        case .create, .onboarding, .collection:
            break
        case .share(let superviewWidth, _, let isBorderOn):
            context = .share(superviewWidth: superviewWidth, isRoundOn: newValue, isBorderOn: isBorderOn)
        }
    }

    // MARK: - Setting Up Width / Height

    func updateSuperViewSize(_ size: CGSize) {
        switch context {
        case .create:
            context = .create(superviewWidth: size.width)
        case .share(_, let isRoundOn, let isBorderOn):
            context = .share(superviewWidth: size.width, isRoundOn: isRoundOn, isBorderOn: isBorderOn)
        case .onboarding, .collection:
            break
        }
    }

    func updateColumnItemWidth(_ width: CGFloat) {
        guard case .collection = context else { return }

        context = .collection(columnItemWidth: width)
    }
    
    // MARK: - Save Album Cover
    
    func saveAlbumCover() {
        database?.store(albumCover: rows)
    }

    // MARK: - EmojiViewDelegate

    func emojiViewDidSelectEmoji(_ emoji: String, emojiView: EmojiView) {
        guard let currentAlbumCoverEmojiInfo = currentAlbumCoverEmojiInfo else { return }

        updateEmoji(emoji, for: currentAlbumCoverEmojiInfo)
    }
    
    // MARK: - Hashable
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: AlbumCoverViewModel, rhs: AlbumCoverViewModel) -> Bool {
        return lhs.id == rhs.id
    }
}

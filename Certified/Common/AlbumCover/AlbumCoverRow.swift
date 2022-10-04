import Foundation

struct AlbumCoverRow {
    
    // MARK: - Properties
    
    var rowNumber: Int
    var emojis: [AlbumCoverEmojiInfo] = []
    
    // MARK: - Init
    
    init(rowNumber: Int) {
        self.rowNumber = rowNumber
        emojis = [
            AlbumCoverEmojiInfo(rowNumber: rowNumber, columnNumber: 0),
            AlbumCoverEmojiInfo(rowNumber: rowNumber, columnNumber: 1),
            AlbumCoverEmojiInfo(rowNumber: rowNumber, columnNumber: 2),
            AlbumCoverEmojiInfo(rowNumber: rowNumber, columnNumber: 3)
        ]
    }
    
    init(rowNumber: Int, setEmojis: [String]) {
        self.rowNumber = rowNumber
        
        var emojis: [AlbumCoverEmojiInfo] = []
        setEmojis.enumerated().forEach { columnNumber, emoji in
            emojis.append(AlbumCoverEmojiInfo(rowNumber: rowNumber, columnNumber: columnNumber, emoji: emoji))
        }
        self.emojis = emojis
    }
}

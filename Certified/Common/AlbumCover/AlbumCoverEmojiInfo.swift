import Foundation

struct AlbumCoverEmojiInfo: Equatable {
    
    // MARK: - Properties
    
    var rowNumber: Int
    var columnNumber: Int
    var emoji: String
    var editMode = EditMode.off
    
    init(rowNumber: Int, columnNumber: Int) {
        self.rowNumber = rowNumber
        self.columnNumber = columnNumber
        
        switch (rowNumber, columnNumber) {
        case (0, 0):
            emoji = "🤰🏾"
        case (0, 1):
            emoji = "🤰🏾"
        case (0, 2):
            emoji = "🤰🏽"
        case (0, 3):
            emoji = "🤰🏿"
        case (1, 0):
            emoji = "🤰🏽"
        case (1, 1):
            emoji = "🤰🏻"
        case (1, 2):
            emoji = "🤰🏾"
        case (1, 3):
            emoji = "🤰🏻"
        case (2, 0):
            emoji = "🤰🏿"
        case (2, 1):
            emoji = "🤰🏽"
        case (2, 2):
            emoji = "🤰🏽"
        case (2, 3):
            emoji = "🤰🏼"
        default:
            emoji = "🤰🏽"
        }
    }
    
    init(rowNumber: Int, columnNumber: Int, emoji: String) {
        self.rowNumber = rowNumber
        self.columnNumber = columnNumber
        self.emoji = emoji
    }
}

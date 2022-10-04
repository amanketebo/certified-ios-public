import Foundation

class Database {
    
    private enum Key: String {
        case albumCovers
    }
    
    // MARK: - Properties
    
    var allAlbumCovers: [[String]] {
        let covers = userDefaults.array(forKey: Key.albumCovers.rawValue) as? [[String]]
        return covers ?? []
    }
 
    private let userDefaults: UserDefaults
    private let notificationCenter: NotificationCenter
    
    // MARK: - Init
    
    init(userDefaults: UserDefaults = .standard, notificationCenter: NotificationCenter = .default) {
        self.userDefaults = userDefaults
        self.notificationCenter = notificationCenter
    }
    
    // MARK: - Save Album Cover
    
    func store(albumCover: [AlbumCoverRow]) {
        let albumCoverEmojiArray = albumCover.flatMap { $0.emojis.map { $0.emoji } }
        var albumCovers = allAlbumCovers
        
        albumCovers.append(albumCoverEmojiArray)
        userDefaults.set(albumCovers, forKey: Key.albumCovers.rawValue)
        notificationCenter.post(name: .databaseDidUpdate, object: nil)
    }
}

import Combine
import SwiftUI

class CoversViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var albumCoverViewModels: [AlbumCoverViewModel] = []
    
    var edgeInsets = EdgeInsets(top: 16, leading: 16, bottom: 32, trailing: 16)
    var interItemSpacing: CGFloat = 16
    var selectedAlbumCoverViewModel: AlbumCoverViewModel?

    var shouldShowEmptyState: Bool {
        albumCoverViewModels.isEmpty
    }
    
    private let database: Database
    private let notificationCenter: NotificationCenter
    private let appTabBarController: AppTabBarController?
    private let numberOfColumns = 2
    
    // MARK: Init
    
    init(database: Database, notificationCenter: NotificationCenter = .default, appTabBarController: AppTabBarController?) {
        self.database = database
        self.notificationCenter = notificationCenter
        self.appTabBarController = appTabBarController
        
        notificationCenter.addObserver(
            self,
            selector: #selector(databaseDidUpdate),
            name: .databaseDidUpdate,
            object: nil
        )
    }
    
    // MARK: - Layout

    func columnWidth(for viewWidth: CGFloat) -> CGFloat {
        return (viewWidth - (edgeInsets.leading + edgeInsets.trailing + interItemSpacing)) / CGFloat(numberOfColumns)
    }

    func columnGridItems(for viewWidth: CGFloat) -> [GridItem] {
        var columns: [GridItem] = []
        
        for _ in 0..<numberOfColumns {
            let columnWidth = columnWidth(for: viewWidth)
            let item = GridItem(.fixed(columnWidth), spacing: interItemSpacing)
            columns.append(item)
        }
        
        return columns
    }
    
    // MARK: Update

    func fetchAlbumCovers() {
        albumCoverViewModels = database.allAlbumCovers.map { emojiString in
            AlbumCoverViewModel(context: .collection(columnItemWidth: columnWidth(for: 0)), albumCoverRows: emojiString.chunked(into: 4))
        }
    }

    // MARK: - Navigation

    func switchToCreateTabAndBeginEditing() {
        appTabBarController?.switchToCreateTabAndBeginEditing()
    }
    
    // MARK: - DatabaseDelegate
    
    @objc func databaseDidUpdate() {
        // Get new album covers from database
    }
}

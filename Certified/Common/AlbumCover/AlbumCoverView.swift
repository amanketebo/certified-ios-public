import SwiftUI

struct AlbumCoverView: View {
    
    // MARK: - Properties
    
    @ObservedObject var viewModel: AlbumCoverViewModel
    @EnvironmentObject var themeManager: ThemeManager

    // MARK: - Init

    init(viewModel: AlbumCoverViewModel) {
        self.viewModel = viewModel
    }

    init(viewModel: AlbumCoverViewModel, collectionColumnItemWidth: CGFloat) {
        viewModel.updateColumnItemWidth(collectionColumnItemWidth)
        self.viewModel = viewModel
    }
    
    // MARK: - View

    var body: some View {
        VStack(spacing: viewModel.albumCoverVerticalSpacing) {
            ForEach(viewModel.rows, id: \.rowNumber) { albumCoverRow in
                HStack(spacing: 0) {
                    if viewModel.shouldUseTextField {
                        ForEach(albumCoverRow.emojis, id: \.columnNumber) { albumCoverEmojiInfo in
                            EmojiTextField(viewModel: viewModel, albumCoverEmojiInfo: albumCoverEmojiInfo)
                                .accentColor(Color.clear)
                                .shadow(
                                    color: Colors.CreateTab.albumCoverEmojiShadowColor.swiftUIColor(for: themeManager.currentTheme),
                                    radius: viewModel.emojiRadiusShadow(for: albumCoverEmojiInfo),
                                    x: 0,
                                    y: viewModel.emojiYShadowOffset(for: albumCoverEmojiInfo)
                                )
                        }
                    } else {
                        ForEach(albumCoverRow.emojis, id: \.columnNumber) { albumCoverEmoji in
                            Text(albumCoverEmoji.emoji)
                                .font(viewModel.albumCoverFont.swiftUIFont)
                        }
                    }
                }
            }
        }
        .if(viewModel.shouldUseMaxWidthAndHeight) { view in
            view.frame(maxWidth: 326, maxHeight: 340)
        }
        .if(!viewModel.shouldUseMaxWidthAndHeight) { view in
            view.frame(width: viewModel.exactViewWidthWithoutPadding, height: viewModel.exactViewHeightWithoutPadding)
        }
        .padding(viewModel.albumCoverPadding)
        .background(Colors.CreateTab.albumCoverBackgroundColor.swiftUIColor(for: themeManager.currentTheme))
        .cornerRadius(viewModel.cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: viewModel.cornerRadius)
                .strokeBorder(
                    Colors.CreateTab.albumCoverBorderColor.swiftUIColor(for: themeManager.currentTheme),
                    lineWidth: viewModel.borderWidth
                )
                .opacity(viewModel.shouldShowBorder ? 1 : 0)
        )
        .if(viewModel.shouldAddShadow) { view in
            view.shadow(
                color: Colors.CreateTab.albumCoverBackgroundShadowColor.swiftUIColor(for: themeManager.currentTheme),
                radius: 20,
                x: 0,
                y: 8
            )
        }
    }
}

struct AlbumCoverView_Previews: PreviewProvider {

    static var previews: some View {
        let context = AlbumCoverViewModel.Context.create(superviewWidth: 375)
        let viewModel = AlbumCoverViewModel(context: context, database: .init())
        AlbumCoverView(viewModel: viewModel)
            .previewLayout(.sizeThatFits)
            .background(.black)
    }
}

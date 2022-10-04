import SwiftUI

struct ShareView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var themeManager: ThemeManager

    @State var albumCoverViewModel: AlbumCoverViewModel

    var body: some View {
        GeometryReader { shareViewProxy in
            VStack(spacing: 0) {
                ShareTopBar()
                ScrollView(.vertical) {
                    VStack(spacing: 0) {
                        let styleSectionModel = ShareStyleSectionModel(
                            shareViewProxy: shareViewProxy,
                            albumCoverViewModel: albumCoverViewModel
                        )
                        ShareStyleSectionView(
                            model: styleSectionModel
                        )
                        Spacer(minLength: 16)
                        let shareSectionModel = ShareShareSectionModel(
                            shareViewProxy: shareViewProxy,
                            leadingTrailingPadding: styleSectionModel.leadingTrailingPadding,
                            albumCoverViewModel: albumCoverViewModel
                        )
                        ShareShareSectionView(model: shareSectionModel)
                        Spacer(minLength: 32)
                    }
                }
            }
            .onAppear {
                albumCoverViewModel.updateSuperViewSize(shareViewProxy.size)
            }
        }
        .background(Colors.Common.viewBackgroundColor)
    }
}

struct ShareView_Previews: PreviewProvider {
    static var previews: some View {
        let model = AlbumCoverViewModel(context: .share(superviewWidth: 100, isRoundOn: true, isBorderOn: true))
        ShareView(albumCoverViewModel: model)
            .environmentObject(ThemeManager.shared)
    }
}

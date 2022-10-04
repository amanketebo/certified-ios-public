import SwiftUI

struct CoversView: View {
    
    @ObservedObject var viewModel: CoversViewModel
    @EnvironmentObject var themeManager: ThemeManager
    @State var isSaveSheetPresented = false

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                // Non-empty state
                ScrollView {
                    LazyVGrid(columns: viewModel.columnGridItems(for: proxy.size.width), spacing: viewModel.interItemSpacing) {
                        ForEach(viewModel.albumCoverViewModels) { albumCoverViewModel in
                            AlbumCoverView(
                                viewModel: albumCoverViewModel,
                                collectionColumnItemWidth: viewModel.columnWidth(for: proxy.size.width)
                            )
                            .onTapGesture {
                                viewModel.selectedAlbumCoverViewModel = albumCoverViewModel
                                isSaveSheetPresented = true
                            }
                        }
                    }
                    .padding(viewModel.edgeInsets)
                    .opacity(viewModel.shouldShowEmptyState ? 0 : 1)
                }
                // Empty state
                CoversEmptyStateView(viewModel: viewModel)
                    .opacity(viewModel.shouldShowEmptyState ? 1 : 0)
            }
            .background(Colors.Common.viewBackgroundColor)
            .sheet(isPresented: $isSaveSheetPresented) {
                ShareView(
                    albumCoverViewModel: AlbumCoverViewModel(
                        context: .share(superviewWidth: 100, isRoundOn: true, isBorderOn: true),
                        rows: viewModel.selectedAlbumCoverViewModel?.rows ?? []
                    )
                )
            }
        }
        .navigationTitle(LocalizedString.Covers.navBarTitle)
        .onAppear {
            viewModel.fetchAlbumCovers()
        }
    }
}

struct CoversView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = CoversViewModel(database: .init(), appTabBarController: AppTabBarController())
        CoversView(viewModel: viewModel)
    }
}

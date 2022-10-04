import SwiftUI

struct ShareStyleSectionView: View {
    
    @EnvironmentObject var themeManager: ThemeManager

    @State var parentScrollViewSize: CGFloat = 0
    @State var currentOffset: CGFloat = 0
    @State var maxOffset: CGFloat = 0

    @ObservedObject var model: ShareStyleSectionModel

    var body: some View {
        Group {
            Spacer(minLength: 16)
            ShareSectionTitleView(title: model.title)
            Spacer(minLength: 12)
            AlbumCoverView(viewModel: model.albumCoverViewModel)
            Spacer(minLength: 12)
            VStack(spacing: 1) {
                ZStack {
                    Rectangle()
                        .foregroundColor(Colors.Common.cellBackgroundColor)
                        .cornerRadius(16, corners: [.topLeft, .topRight])
                    Toggle("Round", isOn: $model.styleSettings.isRoundOn)
                        .foregroundColor(Colors.Common.titleTextColor)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .onChange(of: model.styleSettings.isRoundOn) { newValue in
                            model.updateIsRoundOn(newValue)
                        }
                }
                ZStack {
                    Rectangle()
                        .foregroundColor(Colors.Common.cellBackgroundColor)
                        .cornerRadius(16, corners: [.bottomLeft, .bottomRight])
                    Toggle("Border", isOn: $model.styleSettings.isBorderOn)
                        .foregroundColor(Colors.Common.titleTextColor)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .onChange(of: model.styleSettings.isBorderOn) { newValue in
                            model.updateIsBorderOn(newValue)
                        }
                }
            }
        }
        .padding([.leading, .trailing], model.leadingTrailingPadding)
        .onAppear {
            model.fetchStyleSettings()
            model.updateIsRoundOn(model.styleSettings.isRoundOn)
            model.updateIsBorderOn(model.styleSettings.isBorderOn)
        }
    }
}

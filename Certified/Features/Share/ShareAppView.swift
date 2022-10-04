import SwiftUI

struct ShareAppView: View {

    @EnvironmentObject var themeManager: ThemeManager
    let model: ShareAppViewModel

    var body: some View {
        VStack {
            topViewInStack()
                .frame(width: model.imageWidthHeight, height: model.imageWidthHeight)
            model.title
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(Colors.CoversTab.shareAppTitleColor)
        }
    }

    @ViewBuilder
    func topViewInStack() -> some View {
        switch model.shareApp {
        case .photos:
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color.white)
                model.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        case .messages:
            model.image
                .resizable()
                .aspectRatio(contentMode: .fit)
        case .other:
            ZStack {
                // Workaround for making sure user can tap inside the stroke and have the button call the action block.
                Color(Colors.Common.viewBackgroundColor.uiKitColor(for: themeManager.currentTheme))
                
                let strokeStyle = StrokeStyle(
                    lineWidth: 3,
                    lineCap: .round,
                    lineJoin: .round,
                    miterLimit: 3,
                    dash: [5, 5, 5],
                    dashPhase: 3
                )
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(style: strokeStyle)
                model.image
                    .font(.system(size: 40, weight: .regular))
            }
        }
    }
}

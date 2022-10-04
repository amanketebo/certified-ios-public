import SwiftUI

struct ShareTopBar: View {
    
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        ZStack {
            Text("Share")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(Colors.Common.navBarTintColor)
                .padding([.top, .bottom], 16)
            HStack {
                Spacer()
                ShareCloseButton()
            }
        }
        .background(
            Rectangle()
                .foregroundColor(Colors.CoversTab.shareTopBarBackgroundColor)
        )
    }
}

import SwiftUI

struct ShareSectionTitleView: View {

    @EnvironmentObject var themeManager: ThemeManager
    let title: String

    var body: some View {
        HStack {
            Text(title.uppercased())
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(Colors.CoversTab.shareSectionTitleColor)
            Spacer()
        }
    }
}

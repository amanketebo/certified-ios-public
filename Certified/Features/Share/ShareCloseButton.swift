import SwiftUI

struct ShareCloseButton: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        Button {
            dismiss()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .foregroundColor(Colors.CoversTab.shareCloseButtonBackgroundColor)
                    .frame(width: 28, height: 28)
                Image(systemName: "xmark")
                    .resizable()
                    .font(.system(size: 10, weight: .bold))
                    .frame(width: 10, height: 10)
                    .foregroundColor(Colors.CoversTab.shareCloseXColor)
            }
            .frame(width: 44, height: 44)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

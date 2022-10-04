import SwiftUI

struct SettingsInfoView: View {

    @EnvironmentObject var themeManager: ThemeManager

    var model: SettingsInfoModel

    var body: some View {
        HStack {
            Image(systemName: model.imageSystemName)
                .resizable()
                .font(.system(size: 25, weight: .semibold))
                .scaledToFit()
                .foregroundColor(Colors.Common.cellImageColor)
                .frame(width: 35, height: 30)
            VStack(alignment: .leading) {
                Text(model.title)
                    .font(.system(size: 18))
                    .fontWeight(.medium)
                    .foregroundColor(Colors.Common.cellTitleColor)
                Text(model.description)
                    .font(.system(size: 12))
                    .fontWeight(.medium)
                    .foregroundColor(Colors.Common.cellDescriptionColor)
                    .multilineTextAlignment(.leading)
            }
            Spacer()
            if model.shouldShowChevron {
                Text("\(Image(systemName: "chevron.right"))")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Colors.Common.cellImageColor)
            }
        }
    }
}

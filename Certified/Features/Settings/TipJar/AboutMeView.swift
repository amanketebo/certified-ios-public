import SwiftUI

struct AboutMeView: View {

    var viewModel: TipJarViewModel
    @EnvironmentObject var themeManager: ThemeManager

    // MARK: - Properties

    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                Image("Settings/AboutMe/larry-hoover-concert")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 80, alignment: .center)
                    .clipped()
                Image("Settings/AboutMe/profile-pic")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .shadow(
                        color: Colors.SettingsTab.aboutMeImageShadowColor.swiftUIColor(for: themeManager.currentTheme),
                        radius: 4,
                        x: 0,
                        y: 0
                    )
                    .overlay(Circle().stroke(Color.white, lineWidth: 1))
                    .offset(x: 16, y: 40)
            }
            Spacer(minLength: 44)
            HStack {
                (messageIntro + messageAfterIntro)
                    .font(.system(size: 15, weight: .medium))
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            .padding([.leading, .trailing], 16)
            Spacer(minLength: 16)
            Image("Settings/AboutMe/twitter-logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
                .shadow(
                    color: Colors.SettingsTab.aboutMeTwitterShadowColor.swiftUIColor(for: themeManager.currentTheme),
                    radius: 4,
                    x: 0,
                    y: 0
                )
                .padding(.all, 5)
                .onTapGesture {
                    viewModel.openTwitter()
                }
            Spacer(minLength: 16)
        }
        .background(Colors.Common.cellBackgroundColor)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Colors.Common.cellBorderColor.swiftUIColor(for: themeManager.currentTheme), lineWidth: 1)
        )
    }

    // MARK: Helpers

    private var messageIntro: Text {
        Text(LocalizedString.Settings.aboutMeMessageIntro)
            .foregroundColor(Colors.Common.cellTitleColor.swiftUIColor(for: themeManager.currentTheme))
    }

    private var messageAfterIntro: Text {
        Text(LocalizedString.Settings.aboutMeAfterIntro)
            .foregroundColor(Color(.sRGB, red: 92/255, green: 92/255, blue: 92/255, opacity: 1))
    }
}

struct AboutMeView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = TipJarViewModel(appTabBarController: AppTabBarController(), iapManager: InAppPurchaseManager())
        AboutMeView(viewModel: viewModel)
    }
}

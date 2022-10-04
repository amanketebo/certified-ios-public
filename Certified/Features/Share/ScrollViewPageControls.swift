import SwiftUI

struct ScrollViewPageControls: View {

    // MARK: - Properties

    @EnvironmentObject var themeManager: ThemeManager

    let contentSize: CGFloat
    let maxOffset: CGFloat
    let currentOffset: CGFloat

    let pageWidth: CGFloat = 25
    let pageHeight: CGFloat = 8
    let spaceBetweenPages: CGFloat = 4

    // TODO: Clean up!
    var leftWidth: CGFloat {
        if currentOffset == 0 {
            return 25
        } else if currentOffset == 50 {
            return 0
        } else {
            let proportion = 1 - ((-currentOffset) / maxOffset)
            let value = proportion * 25

            if value < 0 {
                return 0
            } else if value > 25 {
                return 25
            } else {
                return value
            }
        }
    }

    var rightWidth: CGFloat {
        if currentOffset == 0 {
            return 0
        } else if currentOffset == 50 {
            return 25
        } else {
            let proportion = ((-currentOffset) / maxOffset)
            let value = proportion * 25

            if value < 0 {
                return 0
            } else if value > 25 {
                return 25
            } else {
                return value
            }
        }
    }

    var body: some View {
        HStack {
            Spacer()
            Text("ROUNDED")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(Colors.CoversTab.shareStyleSpecifierTitleColor)
            Spacer()
        }
        Spacer(minLength: 8)
        HStack {
            Spacer()
            HStack(spacing: spaceBetweenPages) {
                ZStack {
                    RoundedRectangle(cornerRadius: pageHeight)
                        .frame(width: pageWidth, height: pageHeight)
                        .foregroundColor(Colors.CoversTab.sharePageBackgroundColor)
                    HStack {
                        Spacer(minLength: 0)
                        RoundedRectangle(cornerRadius: pageHeight)
                            .frame(width: leftWidth, height: pageHeight)
                            .foregroundColor(Colors.CoversTab.shareSelectedPageBackgroundColor)
                    }
                    .frame(width: pageWidth, height: pageHeight)
                }
                .clipShape(RoundedRectangle(cornerRadius: pageHeight))
                ZStack {
                    RoundedRectangle(cornerRadius: pageHeight)
                        .frame(width: pageWidth, height: pageHeight)
                        .foregroundColor(Colors.CoversTab.sharePageBackgroundColor)
                    HStack {
                        RoundedRectangle(cornerRadius: pageHeight)
                            .frame(width: rightWidth, height: pageHeight)
                            .foregroundColor(Colors.CoversTab.shareSelectedPageBackgroundColor)
                        Spacer(minLength: 0)
                    }
                    .frame(width: pageWidth, height: pageHeight)
                }
                .clipShape(RoundedRectangle(cornerRadius: pageHeight))
            }
            Spacer()
        }
    }
}

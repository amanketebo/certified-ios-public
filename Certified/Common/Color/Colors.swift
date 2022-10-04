import UIKit
import SwiftUI

enum Colors {

    // MARK: - Common
    
    enum Common {

        // Tab Bar

        static let tabBarBackgroundColor = AllColors(
            lightColor: .white.withAlphaComponent(0.95),
            darkColor: UIColor(redInt: 22, greenInt: 22, blueInt: 22),
            knifeTalkColor: UIColor(redInt: 43, greenInt: 43, blueInt: 43)
        )

        static let tabBarSelectedTintColor = AllColors(
            lightColor: .black,
            darkColor: .white,
            knifeTalkColor: UIColor(redInt: 47, greenInt: 255, blueInt: 37)
        )

        static let tabBarNormalTintColor = AllColors(
            lightColor: UIColor(redInt: 112, greenInt: 112, blueInt: 112),
            darkColor: UIColor(redInt: 112, greenInt: 112, blueInt: 112),
            knifeTalkColor: UIColor(redInt: 112, greenInt: 112, blueInt: 112)
        )

        // Nav Bar

        static let navBarTitleColor = AllColors(
            lightColor: .black,
            darkColor: .white,
            knifeTalkColor: UIColor(redInt: 47, greenInt: 255, blueInt: 37)
        )
        static let navBarTintColor = AllColors(
            lightColor: .black,
            darkColor: .white,
            knifeTalkColor: UIColor(redInt: 47, greenInt: 255, blueInt: 37)
        )

        // Main View

        static let viewBackgroundColor = AllColors(
            lightColor: UIColor(redInt: 241, greenInt: 241, blueInt: 241),
            darkColor: UIColor(redInt: 10, greenInt: 10, blueInt: 10),
            knifeTalkColor: UIColor(redInt: 34, greenInt: 34, blueInt: 34)
        )

        // Text

        static let titleTextColor = AllColors(
            lightColor: .black,
            darkColor: .white,
            knifeTalkColor: .white
        )

        // Cells

        static let cellBackgroundColor = AllColors(
            lightColor: .white,
            darkColor: UIColor(redInt: 33, greenInt: 33, blueInt: 33),
            knifeTalkColor: UIColor(redInt: 43, greenInt: 43, blueInt: 43)
        )
        static let cellBorderColor = AllColors(
            lightColor: UIColor(redInt: 218, greenInt: 218, blueInt: 218),
            darkColor: UIColor(redInt: 58, greenInt: 58, blueInt: 58),
            knifeTalkColor: UIColor(redInt: 84, greenInt: 84, blueInt: 84)
        )
        static let cellImageColor = AllColors(
            lightColor: UIColor(redInt: 46, greenInt: 46, blueInt: 46),
            darkColor: UIColor(redInt: 235, greenInt: 235, blueInt: 235),
            knifeTalkColor: UIColor(redInt: 235, greenInt: 235, blueInt: 235)
        )
        static let cellTitleColor = AllColors(
            lightColor: .black,
            darkColor: .white,
            knifeTalkColor: .white
        )
        static let cellDescriptionColor = AllColors(
            lightColor: UIColor(redInt: 187, greenInt: 187, blueInt: 187),
            darkColor: UIColor(redInt: 92, greenInt: 92, blueInt: 92),
            knifeTalkColor: UIColor(redInt: 117, greenInt: 117, blueInt: 117, alpha: 117)
        )
        static let cellChevronColor = AllColors(
            lightColor: UIColor(redInt: 166, greenInt: 166, blueInt: 166),
            darkColor: .white,
            knifeTalkColor: .white
        )
    }

    // MARK: - Create Tab

    enum CreateTab {

        // Album Cover

        static let albumCoverBackgroundColor = AllColors(
            lightColor: .white,
            darkColor: .white,
            knifeTalkColor: .white
        )
        static let albumCoverBackgroundShadowColor = AllColors(
            lightColor: .black.withAlphaComponent(0.10),
            darkColor: .black.withAlphaComponent(0.10),
            knifeTalkColor: .black.withAlphaComponent(0.10)
        )
        static let albumCoverBorderColor = AllColors(
            lightColor: UIColor(redInt: 226, greenInt: 226, blueInt: 226),
            darkColor: UIColor(redInt: 226, greenInt: 226, blueInt: 226),
            knifeTalkColor: UIColor(redInt: 226, greenInt: 226, blueInt: 226)
        )
        static let albumCoverEmojiShadowColor = AllColors(
            lightColor: .black.withAlphaComponent(0.50),
            darkColor: .black.withAlphaComponent(0.50),
            knifeTalkColor: .black.withAlphaComponent(0.50)
        )

        // Back Button

        static let backButtonBackgroundColor = AllColors(
            lightColor: UIColor(redInt: 28, greenInt: 28, blueInt: 30),
            darkColor: UIColor(redInt: 28, greenInt: 28, blueInt: 30),
            knifeTalkColor: UIColor(redInt: 28, greenInt: 28, blueInt: 30)
        )
        static let backButtonShadowColor = AllColors(
            lightColor: UIColor(redInt: 28, greenInt: 28, blueInt: 30, alpha: 0.50),
            darkColor: UIColor(redInt: 99, greenInt: 99, blueInt: 102, alpha: 0.50),
            knifeTalkColor: UIColor(redInt: 99, greenInt: 99, blueInt: 102, alpha: 0.50)
        )

        // Add Cover Button

        static let addCoverButtonBackgroundColor = AllColors(
            lightColor: UIColor(redInt: 175, greenInt: 82, blueInt: 222),
            darkColor: UIColor(redInt: 175, greenInt: 82, blueInt: 222),
            knifeTalkColor: UIColor(redInt: 175, greenInt: 82, blueInt: 222)
        )
        static let addCoverButtonShadowColor = AllColors(
            lightColor: UIColor(redInt: 175, greenInt: 82, blueInt: 222, alpha: 0.50),
            darkColor: UIColor(redInt: 175, greenInt: 82, blueInt: 222, alpha: 0.50),
            knifeTalkColor: UIColor(redInt: 175, greenInt: 82, blueInt: 222, alpha: 0.50)
        )

        // Onboarding Info View

        static let onboardingInfoViewBackgroundColor = AllColors(
            lightColor: UIColor(redInt: 242, greenInt: 242, blueInt: 247),
            darkColor: .white,
            knifeTalkColor: .white
        )
        static let onboardingInfoViewBorderColor = AllColors(
            lightColor: UIColor(redInt: 226, greenInt: 226, blueInt: 226),
            darkColor: UIColor(redInt: 226, greenInt: 226, blueInt: 226),
            knifeTalkColor: UIColor(redInt: 226, greenInt: 226, blueInt: 226)
        )
        static let onboardingInfoViewTextColor = AllColors(
            lightColor: .black,
            darkColor: .black,
            knifeTalkColor: .black
        )

        // Onboarding Close Button

        static let onboardingCloseButtonBackgroundColor = AllColors(
            lightColor: UIColor(redInt: 28, greenInt: 28, blueInt: 30),
            darkColor: UIColor(redInt: 28, greenInt: 28, blueInt: 30),
            knifeTalkColor: UIColor(redInt: 28, greenInt: 28, blueInt: 30)
        )
        static let onboardingCloseButtonBorderColor = AllColors(
            lightColor: UIColor(redInt: 72, greenInt: 72, blueInt: 74),
            darkColor: UIColor(redInt: 72, greenInt: 72, blueInt: 74),
            knifeTalkColor: UIColor(redInt: 72, greenInt: 72, blueInt: 74)
        )
    }

    // MARK: - Covers Tab

    enum CoversTab {

        // Empty State

        static let emptyStateMessageTitleColor = AllColors(
            lightColor: UIColor(redInt: 100, greenInt: 100, blueInt: 100),
            darkColor: UIColor(redInt: 187, greenInt: 187, blueInt: 187),
            knifeTalkColor: UIColor(redInt: 187, greenInt: 187, blueInt: 187)
        )

        // Create Cover Button

        static let createCoverButtonTitleColor = AllColors(
            lightColor: .white,
            darkColor: .white,
            knifeTalkColor: .white
        )
        static let createCoverButtonMessageColor = AllColors(
            lightColor: UIColor(redInt: 100, greenInt: 100, blueInt: 100),
            darkColor: UIColor(redInt: 187, greenInt: 187, blueInt: 187),
            knifeTalkColor: UIColor(redInt: 187, greenInt: 187, blueInt: 187)
        )
        static let createCoverButtonBackgroundColor = AllColors(
            lightColor: UIColor(redInt: 175, greenInt: 82, blueInt: 222),
            darkColor: UIColor(redInt: 49, greenInt: 5, blueInt: 53),
            knifeTalkColor:  UIColor(redInt: 49, greenInt: 5, blueInt: 53)
        )
        static let createCoverButtonBorderColor = AllColors(
            lightColor: UIColor(redInt: 133, greenInt: 38, blueInt: 182),
            darkColor: UIColor(redInt: 99, greenInt: 39, blueInt: 104),
            knifeTalkColor: UIColor(redInt: 99, greenInt: 39, blueInt: 104)
        )
        static let createCoverButtonShadowColor = AllColors(
            lightColor: UIColor(redInt: 133, greenInt: 38, blueInt: 182, alpha: 0.40),
            darkColor: UIColor(redInt: 100, greenInt: 25, blueInt: 106, alpha: 0.40),
            knifeTalkColor: UIColor(redInt: 100, greenInt: 25, blueInt: 106, alpha: 0.40)
        )

        // Share Screen

        static let shareTopBarBackgroundColor = AllColors(
            lightColor: UIColor(redInt: 232, greenInt: 232, blueInt: 232),
            darkColor: UIColor(redInt: 23, greenInt: 23, blueInt: 23),
            knifeTalkColor: UIColor(redInt: 23, greenInt: 23, blueInt: 23)
        )

        static let shareCloseButtonBackgroundColor = AllColors(
            lightColor: UIColor(redInt: 216, greenInt: 216, blueInt: 216),
            darkColor: UIColor(redInt: 60, greenInt: 60, blueInt: 60),
            knifeTalkColor: UIColor(redInt: 60, greenInt: 60, blueInt: 60)
        )

        static let shareCloseXColor = AllColors(
            lightColor: UIColor(redInt: 80, greenInt: 80, blueInt: 80),
            darkColor: UIColor(redInt: 209, greenInt: 209, blueInt: 209),
            knifeTalkColor: UIColor(redInt: 226, greenInt: 255, blueInt: 224)
        )

        static let shareSectionTitleColor = AllColors(
            lightColor: UIColor(redInt: 174, greenInt: 174, blueInt: 174),
            darkColor: UIColor(redInt: 206, greenInt: 206, blueInt: 206),
            knifeTalkColor: UIColor(redInt: 226, greenInt: 255, blueInt: 224)
        )

        static let shareStyleSpecifierTitleColor = AllColors(
            lightColor: .black,
            darkColor: .white,
            knifeTalkColor: .white
        )

        static let sharePageBackgroundColor = AllColors(
            lightColor: UIColor(redInt: 217, greenInt: 217, blueInt: 217),
            darkColor: UIColor(redInt: 46, greenInt: 46, blueInt: 46),
            knifeTalkColor: UIColor(redInt: 46, greenInt: 46, blueInt: 46)
        )

        static let shareSelectedPageBackgroundColor = AllColors(
            lightColor: UIColor(redInt: 123, greenInt: 97, blueInt: 255),
            darkColor: UIColor(redInt: 123, greenInt: 97, blueInt: 255),
            knifeTalkColor: UIColor(redInt: 47, greenInt: 255, blueInt: 37)
        )

        static let shareAppTitleColor = AllColors(
            lightColor: .black,
            darkColor: .white,
            knifeTalkColor: .white
        )
    }

    // MARK: - Settings Tab

    enum SettingsTab {

        // Certified + Version Build Info

        static let certifiedGradientStartColor = AllColors(
            lightColor: UIColor(redInt: 62, greenInt: 62, blueInt: 62),
            darkColor: UIColor(redInt: 210, greenInt: 210, blueInt: 210),
            knifeTalkColor: UIColor(redInt: 210, greenInt: 210, blueInt: 210)
        )
        static let certifiedGradientEndColor = AllColors(
            lightColor: UIColor(redInt: 113, greenInt: 113, blueInt: 113),
            darkColor: UIColor(redInt: 170, greenInt: 170, blueInt: 170, alpha: 0.75),
            knifeTalkColor: UIColor(redInt: 170, greenInt: 170, blueInt: 170, alpha: 0.75)
        )
        static let versionBuildInfoTitleColor = AllColors(
            lightColor: UIColor(redInt: 107, greenInt: 107, blueInt: 107),
            darkColor: UIColor(redInt: 150, greenInt: 150, blueInt: 150),
            knifeTalkColor: UIColor(redInt: 150, greenInt: 150, blueInt: 150)
        )

        // Tip Jar About Me

        static let aboutMeImageShadowColor = AllColors(
            lightColor: .black.withAlphaComponent(0.25),
            darkColor: .white.withAlphaComponent(0.25),
            knifeTalkColor: .white.withAlphaComponent(0.25)
        )
        static let aboutMeTwitterShadowColor = AllColors(
            lightColor: UIColor(redInt: 54, greenInt: 175, blueInt: 230, alpha: 0.30),
            darkColor: UIColor(redInt: 54, greenInt: 175, blueInt: 230, alpha: 0.30),
            knifeTalkColor: UIColor(redInt: 54, greenInt: 175, blueInt: 230, alpha: 0.30)
        )

        // Tip Jar Tips

        static let smallTipTextColor = AllColors(
            lightColor: .white,
            darkColor: UIColor(redInt: 212, greenInt: 103, blueInt: 220),
            knifeTalkColor: UIColor(redInt: 212, greenInt: 103, blueInt: 220)
        )
        static let smallTipBackgroundColor = AllColors(
            lightColor: UIColor(redInt: 160, greenInt: 62, blueInt: 168),
            darkColor: UIColor(redInt: 42, greenInt: 23, blueInt: 44),
            knifeTalkColor: UIColor(redInt: 42, greenInt: 23, blueInt: 44)
        )
        static let smallTipBorderColor = AllColors(
            lightColor: UIColor(redInt: 86, greenInt: 9, blueInt: 91),
            darkColor: UIColor(redInt: 86, greenInt: 9, blueInt: 91),
            knifeTalkColor: UIColor(redInt: 86, greenInt: 9, blueInt: 91)
        )
        static let mediumTipTextColor = AllColors(
            lightColor: .white,
            darkColor: UIColor(redInt: 119, greenInt: 220, blueInt: 103),
            knifeTalkColor: UIColor(redInt: 119, greenInt: 220, blueInt: 103)
        )
        static let mediumTipBackgroundColor = AllColors(
            lightColor: UIColor(redInt: 87, greenInt: 148, blueInt: 39),
            darkColor: UIColor(redInt: 32, greenInt: 44, blueInt: 23),
            knifeTalkColor: UIColor(redInt: 32, greenInt: 44, blueInt: 23)
        )
        static let mediumTipBorderColor = AllColors(
            lightColor: UIColor(redInt: 50, greenInt: 91, blueInt: 9),
            darkColor: UIColor(redInt: 50, greenInt: 91, blueInt: 9),
            knifeTalkColor: UIColor(redInt: 50, greenInt: 91, blueInt: 9)
        )
        static let largeTipTextColor = AllColors(
            lightColor: .white,
            darkColor: UIColor(redInt: 103, greenInt: 199, blueInt: 220),
            knifeTalkColor: UIColor(redInt: 103, greenInt: 199, blueInt: 220)
        )
        static let largeTipBackgroundColor = AllColors(
            lightColor: UIColor(redInt: 23, greenInt: 158, blueInt: 158),
            darkColor: UIColor(redInt: 23, greenInt: 44, blueInt: 44),
            knifeTalkColor: UIColor(redInt: 23, greenInt: 44, blueInt: 44)
        )
        static let largeTipBorderColor = AllColors(
            lightColor: UIColor(redInt: 9, greenInt: 72, blueInt: 91),
            darkColor: UIColor(redInt: 9, greenInt: 72, blueInt: 91),
            knifeTalkColor: UIColor(redInt: 9, greenInt: 72, blueInt: 91)
        )
    }
}

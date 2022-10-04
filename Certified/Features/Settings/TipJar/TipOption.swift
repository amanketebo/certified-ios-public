import Foundation
import SwiftUI

struct TipOption: Identifiable {

    // MARK: - Properties

    let iapProduct: IAPProduct

    let emoji: String
    let title: String
    let priceString: String
    let textColor: Color
    let backgroundColor: Color
    let borderColor: Color

    // MARK: Identifiable

    var id: IAPType {
        iapProduct.type
    }

    // MARK: - Init

    init(iapProduct: IAPProduct, theme: ThemeManager.Theme) {
        self.iapProduct = iapProduct

        switch iapProduct.type {
        case .smallTip:
            emoji = "☕️"
            title = "Small Tip"
            priceString = "$2.99"
            textColor = Colors.SettingsTab.smallTipTextColor.swiftUIColor(for: theme)
            backgroundColor = Colors.SettingsTab.smallTipBackgroundColor.swiftUIColor(for: theme)
            borderColor = Colors.SettingsTab.smallTipBorderColor.swiftUIColor(for: theme)
        case .mediumTip:
            emoji = "🌯"
            title = "Medium Tip"
            priceString = "$9.99"
            textColor = Colors.SettingsTab.mediumTipTextColor.swiftUIColor(for: theme)
            backgroundColor = Colors.SettingsTab.mediumTipBackgroundColor.swiftUIColor(for: theme)
            borderColor = Colors.SettingsTab.mediumTipBorderColor.swiftUIColor(for: theme)
        case .largeTip:
            emoji = "⛽️"
            title = "Large Tip"
            priceString = "$19.99"
            textColor = Colors.SettingsTab.largeTipTextColor.swiftUIColor(for: theme)
            backgroundColor = Colors.SettingsTab.largeTipBackgroundColor.swiftUIColor(for: theme)
            borderColor = Colors.SettingsTab.largeTipBorderColor.swiftUIColor(for: theme)
        }
    }
}

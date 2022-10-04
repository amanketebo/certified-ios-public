import SwiftUI

struct TipOptionView: View {

    // MARK: - Properties

    @EnvironmentObject var themeManager: ThemeManager

    private let tipOption: TipOption
    private let tipJarViewModel: TipJarViewModel

    var body: some View {
        Button {
            tipJarViewModel.purchase(iapProduct: tipOption.iapProduct)
        } label: {
            HStack {
                Text(tipOption.emoji)
                    .font(.system(size: 25, weight: .semibold))
                Text(tipOption.title)
                    .font(.system(size: 18, weight: .medium))
                Spacer()
                TipPriceView(tipOption: tipOption)
            }
            .customSettingsItemStyle(for: themeManager.currentTheme)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Init

    init(tipOption: TipOption, tipJarViewModel: TipJarViewModel) {
        self.tipOption = tipOption
        self.tipJarViewModel = tipJarViewModel
    }
}

struct TipOptionView_Previews: PreviewProvider {
    static var previews: some View {
        let previewProduct = PreviewProduct()
        let iapProduct = IAPProduct(product: previewProduct)!
        let tipOption = TipOption(iapProduct: iapProduct, theme: .system)
        let tipJarViewModel = TipJarViewModel(appTabBarController: nil, iapManager: InAppPurchaseManager())
        
        TipOptionView(tipOption: tipOption, tipJarViewModel: tipJarViewModel)
    }
}

import SwiftUI

struct TipPriceView: View {

    // MARK: - Properties

    private let tipOption: TipOption

    var body: some View {
        Text(tipOption.priceString)
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(tipOption.textColor)
            .padding(EdgeInsets(top: 3, leading: 11, bottom: 3, trailing: 11))
            .background(
                RoundedRectangle(cornerRadius: 11)
                    .foregroundColor(tipOption.backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 11).stroke(tipOption.borderColor, lineWidth: 1)
                    )
            )
    }

    // MARK: - Init

    init(tipOption: TipOption) {
        self.tipOption = tipOption
    }
}

struct TipPriceView_Previews: PreviewProvider {
    static var previews: some View {
        let previewProduct = PreviewProduct()
        let iapProduct = IAPProduct(product: previewProduct)!
        let tipOption = TipOption(iapProduct: iapProduct, theme: .system)

        TipPriceView(tipOption: tipOption)
    }
}

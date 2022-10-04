import Foundation
import StoreKit

// MARK: - IAP Related Types

enum IAPType: CaseIterable {
    case smallTip
    case mediumTip
    case largeTip

    var identifier: String {
        switch self {
        case .smallTip:
            return "com.certified.smallTip"
        case .mediumTip:
            return "com.certified.mediumTip"
        case .largeTip:
            return "com.certified.largeTip"
        }
    }
}

struct IAPProduct {
    let type: IAPType
    let product: ProductProtocol

    init?(product: ProductProtocol) {
        self.product = product

        switch product.id {
        case IAPType.smallTip.identifier:
            type = .smallTip
        case IAPType.mediumTip.identifier:
            type = .mediumTip
        case IAPType.largeTip.identifier:
            type = .largeTip
        default:
            return nil
        }
    }
}

enum IAPError: Error {
    case emptyProductList
    case newPurchaseResultType
}

// MARK: - IAP Class

class InAppPurchaseManager {

    // MARK: - Listen to Transactions

    func listenForTransactions() {
        Task {
            for await result in Transaction.updates {
                await handleVerificationResult(result)
            }
        }
    }

    // MARK: - Fetching Products

    func fetchAvailableTipProducts() async throws -> [IAPProduct] {
        let iapIdentifiers = IAPType.allCases.map { $0.identifier }
        let fetchedProducts = try await Product.products(for: iapIdentifiers)
        let iapProducts = fetchedProducts
            .sorted(by: { $0.price < $1.price })
            .compactMap { IAPProduct(product: $0) }

        guard iapProducts.isEmpty == false else {
            throw IAPError.emptyProductList
        }

        return iapProducts
    }

    // MARK: - Purchase Products

    func purchase(iapProduct: IAPProduct) async throws {
        let result = try await iapProduct.product.purchase(options: [])

        switch result {
        case .success(let verificationResult):
            await handleVerificationResult(verificationResult)
        case .pending, .userCancelled:
            break
        @unknown default:
            assertionFailure("Programmer error: Unknown result type.")
            throw IAPError.newPurchaseResultType
        }
    }

    private func handleVerificationResult(_ result: VerificationResult<Transaction>) async {
        switch result {
        case .verified(let transaction):
            await transaction.finish()
        case .unverified:
            break
        }
    }
}

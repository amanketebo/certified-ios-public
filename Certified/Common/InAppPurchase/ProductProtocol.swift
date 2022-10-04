import Foundation
import StoreKit

// MARK: - Protocol

protocol ProductProtocol {
    var id: String { get }

    func purchase(options: Set<Product.PurchaseOption>) async throws -> Product.PurchaseResult
}

// MARK: - StoreKit Product Extension

extension Product: ProductProtocol { }

// MARK: - SwiftUI Previews Product

struct PreviewProduct: ProductProtocol {
    var id = IAPType.smallTip.identifier

    func purchase(options: Set<Product.PurchaseOption> = []) async throws -> Product.PurchaseResult {
        return .pending
    }
}

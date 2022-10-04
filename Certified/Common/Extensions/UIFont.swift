import UIKit
import SwiftUI

extension UIFont {
    
    var swiftUIFont: Font {
        Font(self as CTFont)
    }
}

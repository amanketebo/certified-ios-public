import SwiftUI

struct RoundedBackground: ViewModifier {
    
    let backgroundColor: Color
    let borderColor: Color
    let lineWidth: CGFloat
    let cornerRadius: CGFloat

    init(backgroundColor: Color, borderColor: Color, lineWidth: CGFloat, cornerRadius: CGFloat) {
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.lineWidth = lineWidth
        self.cornerRadius = cornerRadius
    }

    func body(content: Content) -> some View {
        content.background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .foregroundColor(backgroundColor)
                .overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(borderColor, lineWidth: lineWidth))
        )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    func roundedBackground(backgroundColor: Color, borderColor: Color, lineWidth: CGFloat, cornerRadius: CGFloat) -> some View {
        modifier(
            RoundedBackground(
                backgroundColor: backgroundColor,
                borderColor: borderColor,
                lineWidth: lineWidth,
                cornerRadius: cornerRadius)
        )
    }

    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

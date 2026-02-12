import SwiftUI

struct RoundedCardModifier: ViewModifier {
    var cornerRadius: CGFloat = 12
    var backgroundColor: Color = .backgroundSecondary
    var padding: EdgeInsets = EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
    }
}

extension View {
    func roundedCard(
        cornerRadius: CGFloat = 12,
        backgroundColor: Color = .backgroundSecondary,
        padding: EdgeInsets = EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
    ) -> some View {
        modifier(RoundedCardModifier(
            cornerRadius: cornerRadius,
            backgroundColor: backgroundColor,
            padding: padding
        ))
    }
}

import SwiftUI

struct TextFieldLabelModifier: ViewModifier {
    let required: Bool
    let label: String
    let spacing: CGFloat

    init(required: Bool = false, label: String, spacing: CGFloat = 15) {
        self.required = required
        self.label = label
        self.spacing = spacing
    }

    func body(content: Content) -> some View {
        VStack(alignment: .leading, spacing: spacing) {
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                if required {
                    Text("*")
                        .foregroundColor(.red)
                        .font(.footnote)
                        .bold()
                }
                Text(label)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .fontWeight(.semibold)
            }

            content
        }
    }
}

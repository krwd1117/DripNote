import SwiftUI

public struct CustomMenuPicker<T: Hashable>: View {
    let title: String
    let items: [T]
    let itemTitle: (T) -> String
    @Binding var selection: T
    let required: Bool
    
    public init(
        title: String,
        items: [T],
        itemTitle: @escaping (T) -> String,
        selection: Binding<T>,
        required: Bool = false
    ) {
        self.title = title
        self.items = items
        self.itemTitle = itemTitle
        self._selection = selection
        self.required = required
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                if required {
                    Text("*")
                        .foregroundColor(.red)
                        .font(.footnote)
                        .bold()
                }
                Text(title)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .fontWeight(.semibold)
            }
            
            Menu {
                ForEach(items, id: \.self) { item in
                    Button {
                        selection = item
                    } label: {
                        HStack {
                            Text(itemTitle(item))
                            if selection == item {
                                Image(systemName: "checkmark")
                                    .foregroundColor(Color.Custom.accentBrown.color)
                            }
                        }
                    }
                }
            } label: {
                HStack {
                    Text(itemTitle(selection))
                        .foregroundColor(Color.Custom.darkBrown.color)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color.Custom.darkBrown.color)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.Custom.primaryBackground.color)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.Custom.darkBrown.color.opacity(0.2), lineWidth: 1)
                )
            }
        }
    }
}

#if DEBUG
struct CustomMenuPicker_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CustomMenuPicker(
                title: "선택",
                items: ["옵션 1", "옵션 2", "옵션 3"],
                itemTitle: { $0 },
                selection: .constant("옵션 1"),
                required: true
            )
            .padding()
        }
        .background(Color.Custom.secondaryBackground.color)
        .previewLayout(.sizeThatFits)
    }
}
#endif 
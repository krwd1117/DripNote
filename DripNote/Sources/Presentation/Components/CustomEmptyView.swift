import SwiftUI

struct CustomEmptyView: View {
    let title: String
    let message: String
    let systemImageName: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: systemImageName)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundColor(.gray.opacity(0.6))

            Text(title)
                .font(.title3)
                .fontWeight(.semibold)

            Text(message)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

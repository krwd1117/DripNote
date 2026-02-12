import SwiftUI

struct CustomEmptyView: View {
    let title: String
    let message: String
    let systemImageName: String

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: systemImageName)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundColor(Color.Custom.darkBrown.color.opacity(0.3))
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color.Custom.darkBrown.color)
                
                Text(message)
                    .font(.system(size: 16))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.Custom.darkBrown.color.opacity(0.6))
                    .padding(.horizontal, 32)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.Custom.primaryBackground.color)
    }
}

//#Preview {
//    CustomEmptyView(
//        title: "레시피가 없습니다",
//        message: "나만의 레시피를 추가해보세요",
//        systemImageName: "cup.and.saucer.fill"
//    )
//}

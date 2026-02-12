import SwiftUI

struct BrewTimerPage: View {
    let recipeId: String
    
    var body: some View {
        ZStack {
            Color.backgroundPrimary.edgesIgnoringSafeArea(.all)
            VStack {
                Text("타이머 화면")
                    .font(.appTitle)
                    .foregroundColor(.textPrimary)
                Text("레시피 ID: \(recipeId)")
                    .font(.appBody)
                    .foregroundColor(.textSecondary)
                // 여기에 타이머 로직과 UI가 들어갈 예정
            }
        }
    }
}

struct BrewTimerPage_Previews: PreviewProvider {
    static var previews: some View {
        BrewTimerPage(recipeId: UUID().uuidString)
    }
}

import SwiftUI
import DripNoteDomain

public struct BaristaRecipeRow: View {
    let recipe: BaristaBrewingRecipe
    
    public init(recipe: BaristaBrewingRecipe) {
        self.recipe = recipe
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 상단: 레시피 제목과 좋아요
            HStack {
                Text(recipe.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color.Custom.darkBrown.color)
                
                Spacer()
            }
            
            // 중간: 바리스타 이름과 원두
            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.baristaName)
                    .font(.system(size: 14))
                    .foregroundColor(Color.Custom.darkBrown.color)
                
                Text(recipe.coffeeBeans)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            
            // 하단: 추출 도구와 온도
            HStack(spacing: 12) {
                Label(
                    recipe.brewingMethod.displayName,
                    systemImage: "mug.fill"
                )
                
                Label(
                    String(format: String(localized: "Recipe.Temperature.Format"),
                          Int(recipe.waterTemperature),
                          String(localized: "Unit.Celsius")),
                    systemImage: recipe.brewingTemperature == .hot ? "flame.fill" : "snowflake"
                )
                .foregroundColor(recipe.brewingTemperature == .hot ? Color.Custom.warmTerracotta.color : Color.Custom.calmSky.color)
            }
            .font(.system(size: 12))
            .foregroundColor(Color.Custom.darkBrown.color)
        }
        .padding(16)
        .background(Color.Custom.secondaryBackground.color)
        .cornerRadius(16)
        .shadow(color: Color.Custom.darkBrown.color.opacity(0.05), radius: 4, x: 0, y: 2)
    }
} 
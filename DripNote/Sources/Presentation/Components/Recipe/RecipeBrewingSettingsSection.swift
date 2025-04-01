import SwiftUI
import DripNoteDomain

public struct RecipeBrewingSettingsSection: View {
    let brewingMethod: BrewingMethod
    let brewingTemperature: BrewingTemperature
    let waterTemperature: Double
    let grindSize: String
    let coffeeWeight: Double
    let waterWeight: Double
    
    public init(
        brewingMethod: BrewingMethod,
        brewingTemperature: BrewingTemperature,
        waterTemperature: Double,
        grindSize: String,
        coffeeWeight: Double,
        waterWeight: Double
    ) {
        self.brewingMethod = brewingMethod
        self.brewingTemperature = brewingTemperature
        self.waterTemperature = waterTemperature
        self.grindSize = grindSize
        self.coffeeWeight = coffeeWeight
        self.waterWeight = waterWeight
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("추출 설정")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color.Custom.darkBrown.color)
            
            VStack(spacing: 12) {
                RecipeSettingRow(
                    icon: "mug.fill",
                    title: "추출 도구",
                    value: brewingMethod.displayName
                )
                
                RecipeSettingRow(
                    icon: brewingTemperature == .hot ? "flame.fill" : "snowflake",
                    title: "물 온도",
                    value: "\(Int(waterTemperature))°C",
                    iconColor: brewingTemperature == .hot ? Color.Custom.warmTerracotta.color : Color.Custom.calmSky.color
                )
                
                RecipeSettingRow(
                    icon: "gearshape.fill",
                    title: "분쇄도",
                    value: grindSize
                )
                
                RecipeSettingRow(
                    icon: "scalemass.fill",
                    title: "커피 : 물 비율",
                    value: "\(Int(coffeeWeight))g : \(Int(waterWeight))ml"
                )
            }
        }
        .padding(16)
        .background(Color.Custom.secondaryBackground.color)
        .cornerRadius(12)
    }
}

public struct RecipeSettingRow: View {
    let icon: String
    let title: String
    let value: String
    var iconColor: Color
    
    public init(
        icon: String,
        title: String,
        value: String,
        iconColor: Color = Color.Custom.darkBrown.color
    ) {
        self.icon = icon
        self.title = title
        self.value = value
        self.iconColor = iconColor
    }
    
    public var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(iconColor)
                .frame(width: 24)
            
            Text(title)
                .foregroundColor(Color.Custom.darkBrown.color)
            
            Spacer()
            
            Text(value)
                .foregroundColor(.secondary)
        }
        .font(.system(size: 14))
    }
} 
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
            Text(String(localized: "Recipe.BrewingSettings"))
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color.Custom.darkBrown.color)
            
            VStack(spacing: 12) {
                RecipeSettingRow(
                    icon: "mug.fill",
                    title: String(localized: "Recipe.Method"),
                    value: brewingMethod.displayName
                )
                
                RecipeSettingRow(
                    icon: "thermometer.medium",
                    title: String(localized: "Recipe.Temperature"),
                    value: String(format: String(localized: "Recipe.Temperature.Format"),
                                Int(waterTemperature),
                                String(localized: "Unit.Celsius"))
                )
                
                RecipeSettingRow(
                    icon: "gearshape.fill",
                    title: String(localized: "Recipe.GrindSize"),
                    value: grindSize
                )
                
                RecipeSettingRow(
                    icon: "scalemass.fill",
                    title: String(localized: "Recipe.Ratio"),
                    value: String(format: String(localized: "Recipe.Ratio.Format"),
                                Int(coffeeWeight), String(localized: "Unit.Gram"),
                                Int(waterWeight), String(localized: "Unit.Milliliter"))
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

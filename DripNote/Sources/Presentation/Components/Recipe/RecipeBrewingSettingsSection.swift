import SwiftUI
import DripNoteDomain
import DripNoteThirdParty

public struct RecipeBrewingSettingsSection: View {
    @Environment(\.openURL) private var openURL
    
    @AppStorage("useMetricWeight") private var useMetricWeight: Bool = true
    @AppStorage("useMetricVolume") private var useMetricVolume: Bool = true
    @AppStorage("useMetricTemperature") private var useMetricTemperature: Bool = true
    
    let brewingMethod: BrewingMethod
    let brewingMethodStoreURL: LocalizedURL?
    let brewingTemperature: BrewingTemperature
    let waterTemperature: Double
    let grindSize: String
    let coffeeWeight: Double
    let waterWeight: Double
    
    public init(
        brewingMethod: BrewingMethod,
        brewingMethodStoreURL: LocalizedURL? = nil,
        brewingTemperature: BrewingTemperature,
        waterTemperature: Double,
        grindSize: String,
        coffeeWeight: Double,
        waterWeight: Double
    ) {
        self.brewingMethod = brewingMethod
        self.brewingMethodStoreURL = brewingMethodStoreURL
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
                VStack(spacing: 8) {
                    HStack {
                        RecipeSettingRow(
                            icon: "mug.fill",
                            title: String(localized: "Recipe.Method"),
                            value: brewingMethod.displayName
                        )
                        
                        if let brewingMethodStoreURL = brewingMethodStoreURL?.url() {
                            Spacer()
                            
                            Button(action: {
                                AnalyticsManager().logEvent(
                                    .brewingToolShopClick(
                                        brewingMethod: brewingMethod.displayName,
                                        storeURL: brewingMethodStoreURL.absoluteString
                                    )
                                )
                                openURL(brewingMethodStoreURL)
                            }) {
                                HStack(spacing: 4) {
                                    Text("Recipe.ShopBrewingTool")
                                        .font(.system(size: 12))
                                    Image(systemName: "arrow.up.right")
                                        .font(.system(size: 10))
                                }
                                .foregroundColor(Color.Custom.accentBrown.color)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.Custom.accentBrown.color.opacity(0.1))
                                .clipShape(Capsule())
                            }
                        }
                    }
                    
                    if let _ = brewingMethodStoreURL?.url() {
                        Text("Disclaimer.Affiliate")
                            .font(.system(size: 12))
                            .foregroundColor(Color.Custom.accentBrown.color)
                    }
                }
                
                RecipeSettingRow(
                    icon: "thermometer.medium",
                    title: String(localized: "Recipe.Temperature"),
                    value: String(
                        format: String(localized: "Recipe.Temperature.Format"),
                        Double(useMetricVolume ? waterTemperature : waterTemperature.convertTo(to: .fahrenheit)),
                        String(localized: useMetricVolume ? "Unit.Celsius" : "Unit.Fahrenheit")
                    )
                )
                
                RecipeSettingRow(
                    icon: "gearshape.fill",
                    title: String(localized: "Recipe.GrindSize"),
                    value: grindSize
                )
                
                RecipeSettingRow(
                    icon: "scalemass.fill",
                    title: String(localized: "Recipe.Ratio"),
                    value: String(
                        format: String(localized: "Recipe.Ratio.Format"),
                        Double(useMetricWeight ? coffeeWeight : coffeeWeight.convertTo(to: .oz)), String(localized: useMetricWeight ? "Unit.Gram" : "Unit.Oz"),
                        Double(useMetricVolume ? waterWeight : waterWeight.convertTo(to: .floz)), String(localized: useMetricVolume ? "Unit.Milliliter" : "Unit.Floz")
                    )
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

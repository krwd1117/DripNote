import SwiftUI
import DripNoteDomain

public struct RecipeBasicInfoSection: View {
    let title: String
    let baristaName: String
    let coffeeBeans: String
    let brewingTemperature: BrewingTemperature
    
    public init(
        title: String,
        baristaName: String,
        coffeeBeans: String,
        brewingTemperature: BrewingTemperature
    ) {
        self.title = title
        self.baristaName = baristaName
        self.coffeeBeans = coffeeBeans
        self.brewingTemperature = brewingTemperature
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center, spacing: 8) {
                Text(title)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color.Custom.darkBrown.color)
                
                Spacer()
                
                Image(systemName: brewingTemperature == .hot ? "flame.fill" : "snowflake")
                    .font(.system(size: 18))
                    .foregroundColor(brewingTemperature == .hot ? Color.Custom.warmTerracotta.color : Color.Custom.calmSky.color)
            }
            
            if baristaName.isEmpty == false {
                HStack {
                    Text("by")
                        .foregroundColor(.secondary)
                    Text(baristaName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color.Custom.darkBrown.color)
                }
            }
            
            Text(coffeeBeans)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.Custom.secondaryBackground.color)
        .cornerRadius(12)
    }
} 

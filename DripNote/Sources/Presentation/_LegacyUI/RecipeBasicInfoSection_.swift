import SwiftUI
import DripNoteDomain
import DripNoteThirdParty

public struct RecipeBasicInfoSection: View {
    private var title: String
    private var baristaName: String
    private var coffeeBeans: String
    private var coffeeBeansStoreURL: LocalizedURL?
    private var brewingTemperature: BrewingTemperature
    
    public init(
        title: String,
        baristaName: String,
        coffeeBeans: String,
        coffeeBeansStoreURL: LocalizedURL? = nil,
        brewingTemperature: BrewingTemperature
    ) {
        self.title = title
        self.baristaName = baristaName
        self.coffeeBeans = coffeeBeans
        self.coffeeBeansStoreURL = coffeeBeansStoreURL
        self.brewingTemperature = brewingTemperature
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center, spacing: 8) {
                Text(title)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color.Custom.darkBrown.color)
                    .multilineTextAlignment(.leading)
                
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
            
            if coffeeBeans.isEmpty == false {
                CoffeeBeans(coffeeBeans: coffeeBeans, coffeeBeansStoreURL: coffeeBeansStoreURL)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.Custom.secondaryBackground.color)
        .cornerRadius(12)
    }
    
    struct CoffeeBeans: View {
        @Environment(\.openURL) private var openURL
        
        var coffeeBeans: String
        var coffeeBeansStoreURL: LocalizedURL?
        
        var showAffiliate: Bool {
            guard let urlString = coffeeBeansStoreURL?.url()?.absoluteString.lowercased() else { return false }
            return urlString.contains("coupang")
            || urlString.contains("amzn")
            || urlString.contains("amazon")
        }
        
        var body: some View {
            let storeURL = coffeeBeansStoreURL?.url()

            VStack(spacing: 8) {
                HStack {
                    Text(coffeeBeans)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                    
                    if let storeURL = storeURL {
                        Spacer()
                        
                        Button {
                            AnalyticsManager().logEvent(
                                .coffeeBeansShopClick(
                                    coffeeName: coffeeBeans,
                                    storeURL: storeURL.absoluteString
                                )
                            )
                            openURL(storeURL)
                        } label: {
                            HStack(spacing: 4) {
                                Text("Recipe.ShopCoffeeBeans")
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
                
                if showAffiliate {
                    HStack {
                        Text("Disclaimer.Affiliate")
                            .font(.system(size: 12))
                            .foregroundColor(Color.Custom.accentBrown.color)
                        
                        Spacer()
                    }
                }
            }
        }
    }
}

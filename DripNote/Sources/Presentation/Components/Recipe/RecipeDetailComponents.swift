import SwiftUI
import DripNoteDomain

// MARK: - Basic Info Section
public struct RecipeBasicInfoSection: View {
    let title: String
    let baristaName: String
    let coffeeBeans: String
    
    public init(
        title: String,
        baristaName: String,
        coffeeBeans: String
    ) {
        self.title = title
        self.baristaName = baristaName
        self.coffeeBeans = coffeeBeans
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color.Custom.darkBrown.color)
            
            HStack {
                Text("by")
                    .foregroundColor(.secondary)
                Text(baristaName)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color.Custom.darkBrown.color)
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

// MARK: - Brewing Settings Section
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

// MARK: - Notes Section
public struct RecipeNotesSection: View {
    let notes: String
    
    public init(notes: String) {
        self.notes = notes
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("메모")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color.Custom.darkBrown.color)
            
            Text(notes)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.Custom.secondaryBackground.color)
        .cornerRadius(12)
    }
}

// MARK: - Brewing Steps Section
public struct RecipeBrewingStepsSection<Step: BrewingStepProtocol>: View {
    let steps: [Step]
    
    public init(steps: [Step]) {
        self.steps = steps
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("추출 단계")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color.Custom.darkBrown.color)
            
            VStack(spacing: 12) {
                ForEach(steps.sorted(by: { $0.pourNumber < $1.pourNumber }), id: \.pourNumber) { step in
                    RecipeStepRow(step: step)
                }
            }
        }
        .padding(16)
        .background(Color.Custom.secondaryBackground.color)
        .cornerRadius(12)
    }
}

public struct RecipeStepRow<Step: BrewingStepProtocol>: View {
    let step: Step
    
    public init(step: Step) {
        self.step = step
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("#\(step.pourNumber)")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color.Custom.darkBrown.color)
                
                Spacer()
                
                HStack(spacing: 12) {
                    Label(
                        "\(Int(step.pourAmount))ml",
                        systemImage: "drop.fill"
                    )
                    
                    Label(
                        "\(Int(step.pourTime))초",
                        systemImage: "clock.fill"
                    )
                }
                .font(.system(size: 14))
                .foregroundColor(Color.Custom.accentBrown.color)
            }
            
            if !step.desc.isEmpty {
                Text(step.desc)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
        }
        .padding(12)
        .background(Color.Custom.primaryBackground.color)
        .cornerRadius(8)
    }
} 

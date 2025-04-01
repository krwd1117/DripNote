import SwiftUI
import DripNoteDomain

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
                        String(format: "%d%@", Int(step.pourAmount), String(localized: "Unit.Milliliter")),
                        systemImage: "drop.fill"
                    )
                    
                    Label(
                        String(format: String(localized: "Recipe.Time.SecondsOnly"), Int(step.pourTime)),
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

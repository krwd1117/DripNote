import SwiftUI
import DripNoteDomain

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
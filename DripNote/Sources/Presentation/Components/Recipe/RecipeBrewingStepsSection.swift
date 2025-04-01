import SwiftUI
import DripNoteDomain

public struct RecipeBrewingStepsSection<Step: BrewingStepProtocol>: View {
    let steps: [Step]
    
    public init(steps: [Step]) {
        self.steps = steps
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recipe.BrewingSteps")
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

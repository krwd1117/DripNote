import SwiftUI
import SwiftData

import DripNoteDomain

struct StepFormView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("useMetricVolume") private var useMetricVolume: Bool = true
    
    let viewModel: RecipeFormViewModel
    let editingStep: BrewingStep?
    
    @State private var pourAmount: Double
    @State private var pourTime: Double
    @State private var desc: String
    
    init(viewModel: RecipeFormViewModel, editingStep: BrewingStep? = nil) {
        self.viewModel = viewModel
        self.editingStep = editingStep
        
        if let step = editingStep {
            _pourAmount = State(initialValue: step.pourAmount)
            _pourTime = State(initialValue: step.pourTime)
            _desc = State(initialValue: step.desc)
        } else {
            _pourAmount = State(initialValue: 60)
            _pourTime = State(initialValue: 30)
            _desc = State(initialValue: "")
        }
    }
    
    var isValid: Bool {
        let convertedAmount = useMetricVolume ? pourAmount : pourAmount / 0.033814
        return convertedAmount > 0 && pourTime >= 0
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(String(localized: "Recipe.PouringInfo")) {
                    UnitInputSlider(
                        title: String(localized: "Recipe.WaterVolume"),
                        unit: useMetricVolume ? String(localized: "Unit.Milliliter") : String(localized: "Unit.Floz"),
                        range: useMetricVolume ? 0...300 : 0...10,
                        step: useMetricVolume ? 10 : 0.5,
                        placholder: useMetricVolume ? "60" : "2.0",
                        value: Binding(
                            get: { useMetricVolume ? pourAmount : pourAmount.convertTo(to: .floz) },
                            set: { newValue in
                                pourAmount = useMetricVolume ? newValue : newValue.convertTo(to: .ml)
                            }
                        ),
                        valueFormatter: { value in
                            useMetricVolume ? String(Int(value)) : String(format: "%.2f", value)
                        }
                    )
                    
                    UnitInputSlider(
                        title: String(localized: "Recipe.Time.Label"),
                        unit: String(localized: "Unit.Second"),
                        range: 0...300,
                        step: 10,
                        placholder: "30",
                        value: $pourTime,
                        valueFormatter: { String(Int($0)) }
                    )
                    
                    TextField(String(localized: "Recipe.Description.Placeholder"), text: $desc)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.Custom.primaryBackground.color)
            .navigationTitle(editingStep == nil ?
                String(localized: "Recipe.AddPouringStep") :
                String(localized: "Common.Edit"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(String(localized: "Common.Cancel")) {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(editingStep == nil ?
                        String(localized: "Common.Add") :
                        String(localized: "RecipeForm.Save")
                    ) {
                        saveStep()
                    }
                    .disabled(!isValid)
                }
            }
            .tint(Color.Custom.accentBrown.color)
        }
    }
    
    private func saveStep() {
        if let step = editingStep {
            viewModel.updateStep(
                step,
                pourAmount: pourAmount,
                pourTime: pourTime,
                desc: desc
            )
        } else {
            viewModel.addStep(
                pourAmount: pourAmount,
                pourTime: pourTime,
                desc: desc
            )
        }
        dismiss()
    }
}

import SwiftUI
import SwiftData

import DripNoteDomain

struct StepFormView: View {
    @Environment(\.dismiss) private var dismiss
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
        pourAmount > 0 && pourTime >= 0
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(String(localized: "Recipe.PouringInfo")) {
                    ValueSliderInputView(
                        title: String(localized: "Recipe.WaterVolume"),
                        unit: String(localized: "Unit.Milliliter"),
                        range: 0...300,
                        step: 10,
                        placholder: "60",
                        value: $pourAmount
                    )
                    
                    ValueSliderInputView(
                        title: String(localized: "Recipe.StartTime.Label"),
                        unit: String(localized: "Unit.Second"),
                        range: 0...300,
                        step: 10,
                        placholder: "30",
                        value: $pourTime
                    )
                    
                    TextField(String(localized: "Recipe.Description.Placeholder"), text: $desc)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.Custom.primaryBackground.color)
            .navigationTitle(editingStep == nil ? String(localized: "Recipe.AddPouringStep") : String(localized: "Common.Edit"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(editingStep == nil ? String(localized: "Common.Add") : String(localized: "RecipeForm.Save")) {
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
                    .disabled(!isValid)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(String(localized: "Common.Cancel")) {
                        dismiss()
                    }
                }
            }
            .tint(Color.Custom.accentBrown.color)
        }
    }
}

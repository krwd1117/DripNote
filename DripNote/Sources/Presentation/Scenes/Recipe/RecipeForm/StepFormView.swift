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
        pourAmount > 0 && pourTime > 0
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("푸어링 정보") {
                    ValueSliderInputView(
                        title: "물의 양",
                        unit: "ml",
                        range: 0...200,
                        step: 10,
                        placholder: "60",
                        value: $pourAmount
                    )
                    
                    ValueSliderInputView(
                        title: "시작 시간",
                        unit: "초",
                        range: 0...300,
                        step: 10,
                        placholder: "30",
                        value: $pourTime
                    )
                    
                    TextField("설명 (예: 중심부터 원을 그리며 부어주세요)", text: $desc)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.Custom.primaryBackground.color)
            .navigationTitle(editingStep == nil ? "푸어링 단계 추가" : "푸어링 단계 수정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(editingStep == nil ? "추가" : "완료") {
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
                
                ToolbarItem(placement: .topBarLeading) {
                    Button("취소") {
                        dismiss()
                    }
                }
            }
            .tint(Color.Custom.accentBrown.color)
        }
    }
}

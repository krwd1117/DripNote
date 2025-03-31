import SwiftUI
import SwiftData
import DripNoteDomain
import DripNoteDI

public struct RecipeFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var tabBarState: TabBarState
    
    @StateObject private var viewModel: RecipeFormViewModel
    @State private var showingStepSheet = false
    
    public init(recipe: BrewingRecipe? = nil, useCase: RecipeUseCase) {
        let viewModel = RecipeFormViewModel(recipe: recipe, useCase: useCase)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        Form {
            BasicInfoSection(viewModel: viewModel)
            BrewingSettingsSection(viewModel: viewModel)
            BrewingStepsSection(
                viewModel: viewModel,
                showingStepSheet: $showingStepSheet
            )
            NotesSection(notes: $viewModel.notes)
        }
        .navigationTitle(viewModel.recipe == nil ? "레시피 작성" : "레시피 수정")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("저장") {
                    Task {
                        try? await viewModel.saveRecipe(modelContext: modelContext)
                        dismiss()
                    }
                }
                .disabled(!viewModel.isValidRecipe)
            }
        }
        .sheet(isPresented: $showingStepSheet) {
            AddStepView(viewModel: viewModel)
        }
        .onAppear {
            tabBarState.isVisible = false
        }
        .onDisappear {
            tabBarState.isVisible = true
        }
    }
}

// MARK: - Basic Info Section
private struct BasicInfoSection: View {
    @ObservedObject var viewModel: RecipeFormViewModel
    
    var body: some View {
        Section {
            TextField("ex) 나만의 레시피", text: $viewModel.title)
                .modifier(TextFieldLabelModifier(required: true, label: "레시피 제목"))
            TextField("ex) 나", text: $viewModel.baristaName)
                .modifier(TextFieldLabelModifier(label: "바리스타 이름"))
        }
        .background(Color.white)
    }
}

// MARK: - Brewing Settings Section
private struct BrewingSettingsSection: View {
    @ObservedObject var viewModel: RecipeFormViewModel
    
    var body: some View {
        Section("원두 & 추출 설정") {
            TextField("ex) 어린왕자", text: $viewModel.coffeeBeans)
                .modifier(TextFieldLabelModifier(label: "원두 이름"))
            
            Picker("", selection: $viewModel.selectedMethod) {
                ForEach(BrewingMethod.allCases, id: \.self) { method in
                    Text(method.displayName)
                        .tag(method)
                }
            }
            .modifier(TextFieldLabelModifier(label: "추출도구"))
            
            TextField("ex) 중간 || 27 클릭", text: $viewModel.grindSize)
                .modifier(TextFieldLabelModifier(label: "분쇄도"))
            
            CoffeeWaterTemperatureView(
                coffeeWeight: $viewModel.coffeeWeight,
                waterWeight: $viewModel.waterWeight,
                temperature: $viewModel.waterTemperature
            )
        }
    }
}

// MARK: - Coffee Water Ratio View
fileprivate struct CoffeeWaterTemperatureView: View {
    @Binding var coffeeWeight: Double
    @Binding var waterWeight: Double
    @Binding var temperature: Double
    
    @State private var stringCoffeeWeight: String
    @State private var stringWaterWeight: String
    @State private var stringTemperature: String
    
    init(coffeeWeight: Binding<Double>, waterWeight: Binding<Double>, temperature: Binding<Double>) {
        self._coffeeWeight = coffeeWeight
        self._waterWeight = waterWeight
        self._temperature = temperature
        
        self.stringCoffeeWeight = String(format: "%.1f", coffeeWeight.wrappedValue)
        self.stringWaterWeight = String(format: "%.1f", waterWeight.wrappedValue)
        self.stringTemperature = String(format: "%.1f", temperature.wrappedValue)
    }
    
    var body: some View {
        VStack {
            ValueSliderInputView(
                title: "커피량",
                unit: "g",
                range: 0...100,
                step: 0.5,
                value: $coffeeWeight
            )
            
            ValueSliderInputView(
                title: "물량",
                unit: "ml",
                range: 0...300,
                step: 0.5,
                value: $waterWeight
            )
            
            ValueSliderInputView(
                title: "물 온도",
                unit: "°C",
                range: 0...100,
                step: 1,
                value: $temperature
            )
        }
    }
}

// MARK: - Brewing Steps Section
private struct BrewingStepsSection: View {
    @ObservedObject var viewModel: RecipeFormViewModel
    @Binding var showingStepSheet: Bool
    
    var body: some View {
        Section("추출 단계") {
            if viewModel.steps.isEmpty {
                Text("단계를 추가해주세요")
                    .foregroundColor(.gray)
            } else {
                ForEach(
                    viewModel.steps.sorted(by: { $0.pourNumber < $1.pourNumber }),
                    id: \.pourNumber
                ) { step in
                    BrewingStepRow(step: step)
                }
                .onDelete { indexSet in
                    indexSet.forEach { viewModel.removeStep(at: $0) }
                }
            }
            
            Button {
                showingStepSheet = true
            } label: {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("푸어링 단계 추가")
                }
            }
        }
    }
}

// MARK: - Brewing Step Row
fileprivate struct BrewingStepRow: View {
    let step: BrewingStep
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("#\(step.pourNumber)")
                    .font(.headline)
                    .foregroundColor(.accentColor)
                Spacer()
                Text("\(Int(step.pourAmount))ml")
                    .font(.subheadline)
            }
            Text("\(step.formattedTime)에 시작")
                .font(.caption)
                .foregroundColor(.gray)
            Text(step.desc)
                .font(.body)
        }
        .padding(.vertical, 4)
    }
}

fileprivate struct NotesSection: View {
    @Binding var notes: String
    
    var body: some View {
        Section("메모") {
            TextField("메모를 입력하세요", text: $notes)
        }
    }
}

fileprivate struct ValueSliderInputView: View {
    let title: String
    let unit: String
    let range: ClosedRange<Double>
    let step: Double
    
    @Binding var value: Double
    @State private var stringValue: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                Spacer()
                HStack {
                    TextField("\(value)", text: $stringValue)
                        .keyboardType(.decimalPad)
                        .frame(width: 100)
                        .textFieldStyle(.roundedBorder)
                        .onChange(of: stringValue) { _, newValue in
                            if let newDouble = Double(newValue),
                               newDouble != value,
                               range.contains(newDouble) {
                                value = newDouble
                            }
                        }
                    Text(unit)
                }
            }
            
            Slider(value: $value, in: range, step: step)
                .onChange(of: value) { _, newValue in
                    let newValueString = String(format: "%.1f", newValue)
                    if newValueString != stringValue {
                        stringValue = newValueString
                    }
                }
        }
        .onAppear {
            stringValue = String(format: "%.1f", value)
        }
    }
}

// MARK: - Add Step View
private struct AddStepView: View {
    @Environment(\.dismiss) private var dismiss
    let viewModel: RecipeFormViewModel
    
    @State private var pourAmount: Double = 60
    @State private var pourTime: Double = 0
    @State private var desc: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("푸어링 정보") {
                    ValueSliderInputView(
                        title: "물의 양",
                        unit: "ml",
                        range: 0...200,
                        step: 10,
                        value: $pourAmount
                    )
                    
                    ValueSliderInputView(
                        title: "시작 시간",
                        unit: "초",
                        range: 0...300,
                        step: 10,
                        value: $pourTime
                    )
                    
                    TextField("설명 (예: 중심부터 원을 그리며 부어주세요)", text: $desc)
                }
            }
            .navigationTitle("푸어링 단계 추가")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("추가") {
                        viewModel.addStep(
                            pourAmount: pourAmount,
                            pourTime: pourTime,
                            desc: desc
                        )
                        dismiss()
                    }
                    .disabled(pourAmount <= 0)
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button("취소") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    @StateObject var tabBarState: TabBarState = .init(isVisible: false)
    RecipeFormView(useCase: DIContainer.shared.resolve(RecipeUseCase.self))
        .environmentObject(tabBarState)
}

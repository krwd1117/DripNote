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
        .scrollContentBackground(.hidden)
        .background(Color.Custom.primaryBackground.color)
        .tint(Color.Custom.darkBrown.color)
        .navigationTitle(viewModel.recipe == nil ? "레시피 작성" : "레시피 수정")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(Color.Custom.accentBrown.color)
                }
            }
            
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
        .tint(Color.Custom.accentBrown.color)
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
            VStack(alignment: .leading, spacing: 16) {
                TextField("ex) 나만의 레시피", text: $viewModel.title)
                    .font(.system(size: 16))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .modifier(TextFieldLabelModifier(required: true, label: "레시피 제목"))
                
                TextField("ex) 나", text: $viewModel.baristaName)
                    .font(.system(size: 16))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .modifier(TextFieldLabelModifier(label: "바리스타 이름"))
            }
            .padding(.vertical, 8)
        }
    }
}

// MARK: - Brewing Settings Section
private struct BrewingSettingsSection: View {
    @ObservedObject var viewModel: RecipeFormViewModel
    
    var body: some View {
        Section {
            VStack(spacing: 20) {
                // 원두 정보
                VStack(alignment: .leading, spacing: 16) {
                    TextField("ex) 어린왕자", text: $viewModel.coffeeBeans)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .modifier(TextFieldLabelModifier(required: true, label: "원두 이름"))
                    
                    // 온도 설정 세그먼트
                    VStack(alignment: .leading, spacing: 8) {
                        Text("온도 설정")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .fontWeight(.semibold)
                        
                        TemperatureSegment(brewingTemperature: $viewModel.brewingTemperature)
                    }
                }
                
                // 추출 도구 및 분쇄도
                VStack(alignment: .leading, spacing: 16) {
                    Picker("", selection: $viewModel.selectedMethod) {
                        ForEach(BrewingMethod.allCases, id: \.self) { method in
                            Text(method.displayName)
                                .tag(method)
                        }
                    }
                    .pickerStyle(.menu)
                    .modifier(TextFieldLabelModifier(label: "추출도구"))
                    
                    TextField("ex) 중간 || 27 클릭", text: $viewModel.grindSize)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .modifier(TextFieldLabelModifier(label: "분쇄도"))
                }
                
                // 물량 및 온도 설정
                CoffeeWaterTemperatureView(
                    coffeeWeight: $viewModel.coffeeWeight,
                    waterWeight: $viewModel.waterWeight,
                    temperature: $viewModel.waterTemperature
                )
            }
            .padding(.vertical, 8)
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
    @State private var editingStep: BrewingStep?
    
    var body: some View {
        Section {
            VStack(spacing: 16) {
                if viewModel.steps.isEmpty {
                    EmptyStepsView()
                } else {
                    ForEach(
                        viewModel.steps.sorted(by: { $0.pourNumber < $1.pourNumber }),
                        id: \.pourNumber
                    ) { step in
                        BrewingStepRow(
                            step: step,
                            onEdit: { editingStep = step }
                        )
                        .background(Color(uiColor: .secondarySystemBackground))
                        .cornerRadius(12)
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { viewModel.removeStep(at: $0) }
                    }
                }
                
                AddStepButton(showingStepSheet: $showingStepSheet)
            }
            .padding(.vertical, 8)
        }
        .sheet(item: $editingStep) { step in
            EditStepView(
                viewModel: viewModel,
                step: step
            )
        }
    }
}

// MARK: - Brewing Step Row
fileprivate struct BrewingStepRow: View {
    let step: BrewingStep
    let onEdit: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 상단: 단계 번호와 물량
            HStack {
                Text("#\(step.pourNumber)")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color.Custom.darkBrown.color)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "drop.fill")
                        .foregroundColor(Color.Custom.accentBrown.color)
                    Text("\(Int(step.pourAmount))ml")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Color.Custom.accentBrown.color)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.Custom.lightBrown.color.opacity(0.2))
                )
            }
            
            // 중간: 시작 시간
            HStack(spacing: 6) {
                Image(systemName: "clock.fill")
                    .font(.system(size: 14))
                    .foregroundColor(Color.Custom.darkBrown.color)
                Text("\(step.formattedTime)에 시작")
                    .font(.system(size: 14))
                    .foregroundColor(Color.Custom.darkBrown.color)
            }
            
            // 하단: 설명 (있는 경우에만)
            if !step.desc.isEmpty {
                Text(step.desc)
                    .font(.system(size: 15))
                    .foregroundColor(Color.Custom.darkBrown.color)
                    .padding(.top, 4)
            }
        }
        .padding(16)
        .background(Color.Custom.secondaryBackground.color)
        .cornerRadius(12)
        .shadow(color: Color.Custom.darkBrown.color.opacity(0.05), radius: 3, x: 0, y: 1)
        .onTapGesture {
            onEdit()
        }
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

fileprivate struct TemperatureSegment: View {
    @Binding var brewingTemperature: BrewingTemperature
    @Namespace private var animation
    
    var body: some View {
        HStack {
            ForEach(BrewingTemperature.allCases, id: \.self) { temperature in
                Button {
                    withAnimation(.spring()) {
                        brewingTemperature = temperature
                    }
                } label: {
                    Text(temperature.displayName)
                        .font(.system(size: 14, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .foregroundColor(brewingTemperature == temperature ? .white : Color.Custom.darkBrown.color)
                        .background {
                            if brewingTemperature == temperature {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(temperature == .hot ? Color.Custom.warmTerracotta.color : Color.Custom.calmSky.color)
                                    .matchedGeometryEffect(id: "TAB", in: animation)
                            }
                        }
                        .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.Custom.secondaryBackground.color)
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
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("*")
                        .foregroundColor(Color.Custom.warmTerracotta.color)
                        .font(.footnote)
                        .bold()
                    
                    Text(title)
                        .font(.footnote)
                        .foregroundColor(Color.Custom.darkBrown.color)
                        .fontWeight(.semibold)
                }
                
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
                        .foregroundColor(Color.Custom.darkBrown.color)
                }
            }
            
            Slider(value: $value, in: range, step: step)
                .tint(Color.Custom.accentBrown.color)
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
    @State private var pourTime: Double = 30
    @State private var desc: String = ""
    
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
            .scrollContentBackground(.hidden)
            .background(Color.Custom.primaryBackground.color)
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

private struct EmptyStepsView: View {
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "list.bullet.clipboard")
                .font(.system(size: 40))
                .foregroundColor(.gray)
            Text("단계를 추가해주세요")
                .font(.footnote)
                .foregroundColor(.secondary)
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
    }
}

private struct AddStepButton: View {
    @Binding var showingStepSheet: Bool
    
    var body: some View {
        Button {
            showingStepSheet = true
        } label: {
            HStack {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(Color.Custom.accentBrown.color)
                Text("푸어링 단계 추가")
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.Custom.accentBrown.color)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Color.Custom.secondaryBackground.color)
            .cornerRadius(12)
        }
    }
}

// MARK: - Edit Step View
private struct EditStepView: View {
    @Environment(\.dismiss) private var dismiss
    let viewModel: RecipeFormViewModel
    let step: BrewingStep
    
    @State private var pourAmount: Double
    @State private var pourTime: Double
    @State private var desc: String
    
    init(viewModel: RecipeFormViewModel, step: BrewingStep) {
        self.viewModel = viewModel
        self.step = step
        _pourAmount = State(initialValue: step.pourAmount)
        _pourTime = State(initialValue: step.pourTime)
        _desc = State(initialValue: step.desc)
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
            .scrollContentBackground(.hidden)
            .background(Color.Custom.primaryBackground.color)
            .navigationTitle("푸어링 단계 수정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("완료") {
                        viewModel.updateStep(
                            step,
                            pourAmount: pourAmount,
                            pourTime: pourTime,
                            desc: desc
                        )
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

#Preview {
    @StateObject var tabBarState: TabBarState = .init(isVisible: false)
    RecipeFormView(useCase: DIContainer.shared.resolve(RecipeUseCase.self))
        .environmentObject(tabBarState)
}

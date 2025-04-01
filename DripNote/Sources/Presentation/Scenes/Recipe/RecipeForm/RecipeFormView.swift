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
            
            Section {
                Color.clear
                    .frame(height: 50)
                    .listRowBackground(Color.clear)
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.Custom.primaryBackground.color)
        .ignoresSafeArea(.container, edges: .bottom)
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
        .toolbarBackground(.hidden, for: .tabBar)
        .tint(Color.Custom.accentBrown.color)
        .sheet(isPresented: $showingStepSheet) {
            StepFormView(viewModel: viewModel)
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
                step: 1,
                placholder: "20",
                value: $coffeeWeight
            )
            
            ValueSliderInputView(
                title: "물량",
                unit: "ml",
                range: 0...300,
                step: 1,
                placholder: "200",
                value: $waterWeight
            )
            
            ValueSliderInputView(
                title: "물 온도",
                unit: "°C",
                range: 0...100,
                step: 1,
                placholder: "93",
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
            if viewModel.steps.isEmpty {
                EmptyStepsView()
            } else {
                List {
                    ForEach(
                        viewModel.steps.sorted(by: { $0.pourNumber < $1.pourNumber }),
                        id: \.pourNumber
                    ) { step in
                        BrewingStepRow(
                            step: step,
                            onEdit: { editingStep = step }
                        )
                        .listRowInsets(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                        .listRowSeparator(.hidden)
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button {
                                editingStep = step
                            } label: {
                                Image(systemName: "pencil")
                            }
                            .tint(Color.Custom.accentBrown.color)
                            
                            Button(role: .destructive) {
                                if let index = viewModel.steps.firstIndex(where: { $0.pourNumber == step.pourNumber }) {
                                    viewModel.removeStep(at: index)
                                }
                            } label: {
                                Image(systemName: "trash")
                            }
                            .tint(Color.Custom.warmTerracotta.color)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: Color.Custom.darkBrown.color.opacity(0.05), radius: 3, x: 0, y: 1)
                    }
                }
                .listStyle(.inset)
                .frame(height: CGFloat(viewModel.steps.count) * 108)
            }
            
            AddStepButton(showingStepSheet: $showingStepSheet)
        }
        .padding(.vertical, 8)
        .sheet(item: $editingStep) { step in
            StepFormView(viewModel: viewModel, editingStep: step)
        }
    }
}

// MARK: - Brewing Step Row
fileprivate struct BrewingStepRow: View {
    let step: BrewingStep
    let onEdit: () -> Void
    
    var body: some View {
        Button(action: {
            onEdit()
        }, label: {
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
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        })
        .padding(16)
        .frame(height: 100)
        .background(Color.Custom.secondaryBackground.color)
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

#Preview {
    @StateObject var tabBarState: TabBarState = .init(isVisible: false)
    RecipeFormView(useCase: DIContainer.shared.resolve(RecipeUseCase.self))
        .environmentObject(tabBarState)
}

//#Preview(body: {
//    let viewModel = RecipeFormViewModel(useCase: DIContainer.shared.resolve(RecipeUseCase.self))
//    BrewingStepsSection(viewModel: viewModel, showingStepSheet: .constant(false))
//})

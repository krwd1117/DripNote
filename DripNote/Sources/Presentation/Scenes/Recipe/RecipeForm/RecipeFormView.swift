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
    @State private var editingStep: BrewingStep?
    
    public init(recipe: BrewingRecipe? = nil, useCase: RecipeUseCase) {
        let viewModel = RecipeFormViewModel(recipe: recipe, useCase: useCase)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 기본 정보
                BrewingInfoView(viewModel: viewModel)
                
                // 추출 설정
                BrewingSettingsView(viewModel: viewModel)
                
                // 추출 단계
                BrewingStepsView(
                    viewModel: viewModel,
                    showingStepSheet: $showingStepSheet,
                    onEdit: { step in
                        editingStep = step
                        showingStepSheet = true
                    }
                )
                
                // 노트
                NotesView(notes: $viewModel.notes)
                
                Color.clear
                    .frame(height: 50)
            }
            .padding(16)
        }
        .enableNavigationGesture()
        .onTapHideKeyboard()
        .scrollContentBackground(.hidden)
        .background(Color.Custom.primaryBackground.color)
        .ignoresSafeArea(.container, edges: .bottom)
        .tint(Color.Custom.darkBrown.color)
        .navigationTitle(viewModel.recipe == nil ?
                         String(localized: "RecipeForm.Title.New") :
                            String(localized: "RecipeForm.Title.Edit"))
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
                Button(String(localized: "RecipeForm.Save")) {
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
            if let editingStep = editingStep {
                StepFormView(viewModel: viewModel, editingStep: editingStep)
            } else {
                StepFormView(viewModel: viewModel)
            }
        }
        .onAppear {
            tabBarState.isVisible = false
        }
        .onDisappear {
            tabBarState.isVisible = true
        }
        .onChange(of: showingStepSheet) { _, newValue in
            if !newValue {
                editingStep = nil
            }
        }
    }
}

// MARK: - BrewingInfoView
private struct BrewingInfoView: View {
    @ObservedObject var viewModel: RecipeFormViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Recipe.BrewingInfo")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color.Custom.darkBrown.color)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 16) {
                TextField("", text: $viewModel.title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .modifier(TextFieldLabelModifier(
                        required: true,
                        label: String(localized: "RecipeForm.RecipeTitle")
                    ))
                
                TextField("", text: $viewModel.baristaName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .modifier(TextFieldLabelModifier(
                        label: String(localized: "RecipeForm.BaristaName")
                    ))
                
                TextField("", text: $viewModel.coffeeBeans)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .modifier(TextFieldLabelModifier(
                        label: String(localized: "Recipe.CoffeeBeans")
                    ))
                }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Recipe.TemperatureSetting")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .fontWeight(.semibold)
                
                TemperatureSegment(brewingTemperature: $viewModel.brewingTemperature)
            }
        }
        .padding(16)
        .background(Color.Custom.secondaryBackground.color)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.Custom.darkBrown.color.opacity(0.1), lineWidth: 1)
        )
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
}

// MARK: - BrewingSettingsView
private struct BrewingSettingsView: View {
    @ObservedObject var viewModel: RecipeFormViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Recipe.BrewingSettings")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color.Custom.darkBrown.color)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 16) {
                Picker("", selection: $viewModel.selectedMethod) {
                    ForEach(BrewingMethod.allCases, id: \.self) { method in
                        Text(method.displayName)
                            .tag(method)
                    }
                }
                .pickerStyle(.menu)
                .modifier(TextFieldLabelModifier(
                    required: true,
                    label: String(localized: "Recipe.Method")
                ))
                
                TextField("", text: $viewModel.grindSize)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .modifier(TextFieldLabelModifier(
                        label: String(localized: "Recipe.GrindSize")
                    ))
            }
            
            VStack(spacing: 16) {
                ValueSliderInputView(
                    title: String(localized: "Recipe.CoffeeAmount"),
                    unit: String(localized: "Unit.Gram"),
                    range: 0...100,
                    step: 1,
                    placholder: "20",
                    value: $viewModel.coffeeWeight
                )
                
                ValueSliderInputView(
                    title: String(localized: "Recipe.WaterAmount"),
                    unit: String(localized: "Unit.Milliliter"),
                    range: 0...500,
                    step: 10,
                    placholder: "200",
                    value: $viewModel.waterWeight
                )
                
                ValueSliderInputView(
                    title: String(localized: "Recipe.WaterTemperature"),
                    unit: String(localized: "Unit.Celsius"),
                    range: 0...100,
                    step: 1,
                    placholder: "93",
                    value: $viewModel.waterTemperature
                )
            }
        }
        .padding(16)
        .background(Color.Custom.secondaryBackground.color)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.Custom.darkBrown.color.opacity(0.1), lineWidth: 1)
        )
    }
    
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
                    title: String(localized: "Recipe.CoffeeAmount"),
                    unit: String(localized: "Unit.Gram"),
                    range: 0...100,
                    step: 1,
                    placholder: "20",
                    value: $coffeeWeight
                )
                
                ValueSliderInputView(
                    title: String(localized: "Recipe.WaterAmount"),
                    unit: String(localized: "Unit.Milliliter"),
                    range: 0...500,
                    step: 10,
                    placholder: "200",
                    value: $waterWeight
                )
                
                ValueSliderInputView(
                    title: String(localized: "Recipe.WaterTemperature"),
                    unit: String(localized: "Unit.Celsius"),
                    range: 0...100,
                    step: 1,
                    placholder: "93",
                    value: $temperature
                )
            }
        }
    }
}

// MARK: - BrewingStepsView
private struct BrewingStepsView: View {
    @ObservedObject var viewModel: RecipeFormViewModel
    @Binding var showingStepSheet: Bool
    let onEdit: (BrewingStep) -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Recipe.BrewingSteps")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color.Custom.darkBrown.color)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if viewModel.steps.isEmpty {
                EmptyStepsView()
            } else {
                VStack(spacing: 12) {
                    ForEach(
                        viewModel.steps.sorted(by: { $0.pourNumber < $1.pourNumber }),
                        id: \.pourNumber
                    ) { step in
                        Button(action: {
                            onEdit(step)
                        }, label: {
                            RecipeStepRow(step: step)
                        })
                        .buttonStyle(PlainButtonStyle())
                        .shadow(color: Color.Custom.darkBrown.color.opacity(0.05), radius: 3, x: 0, y: 1)
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                if let index = viewModel.steps.firstIndex(where: { $0.pourNumber == step.pourNumber }) {
                                    viewModel.removeStep(at: index)
                                }
                            } label: {
                                Image(systemName: "trash")
                            }
                            .tint(Color.Custom.warmTerracotta.color)
                        }
                    }
                }
            }
            
            AddStepButton(showingStepSheet: $showingStepSheet)
        }
        .padding(16)
        .background(Color.Custom.secondaryBackground.color)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.Custom.darkBrown.color.opacity(0.1), lineWidth: 1)
        )
    }
    
    private struct EmptyStepsView: View {
        var body: some View {
            VStack(spacing: 12) {
                Image(systemName: "list.bullet.clipboard")
                    .font(.system(size: 40))
                    .foregroundColor(Color.Custom.darkBrown.color.opacity(0.3))
                Text("Recipe.Steps.Empty")
                    .font(.system(size: 14))
                    .foregroundColor(Color.Custom.darkBrown.color.opacity(0.5))
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 32)
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
                        .font(.system(size: 16))
                    Text("Recipe.AddPouringStep")
                        .font(.system(size: 14, weight: .semibold))
                }
                .foregroundColor(Color.Custom.accentBrown.color)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.Custom.primaryBackground.color)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(Color.Custom.accentBrown.color, lineWidth: 1)
                )
            }
        }
    }
}

// MARK: - NotesView
fileprivate struct NotesView: View {
    @Binding var notes: String
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "note.text")
                    .font(.system(size: 18, weight: .semibold))
                Text("Recipe.Notes")
                    .font(.system(size: 18, weight: .bold))
            }
            .foregroundColor(Color.Custom.darkBrown.color)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            TextField(
                String(localized: "Recipe.Notes.Placeholder"),
                text: $notes,
                axis: .vertical
            )
            .lineLimit(5...10)
            .textFieldStyle(.plain)
            .font(.system(size: 14))
        }
        .padding(16)
        .background(Color.Custom.secondaryBackground.color)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.Custom.darkBrown.color.opacity(0.1), lineWidth: 1)
        )
    }
}

#Preview {
    @Previewable @StateObject var tabBarState: TabBarState = .init(isVisible: false)
    RecipeFormView(useCase: DIContainer.shared.resolve(RecipeUseCase.self))
        .environmentObject(tabBarState)
}

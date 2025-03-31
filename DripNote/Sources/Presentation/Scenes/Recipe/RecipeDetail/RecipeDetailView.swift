import SwiftUI
import SwiftData
import DripNoteDomain

public struct RecipeDetailView: View {
    @EnvironmentObject private var coordinator: RecipeCoordinator
    @EnvironmentObject private var tabBarState: TabBarState
    @StateObject private var viewModel: RecipeDetailViewModel
    
    public init(viewModel: RecipeDetailViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // 상단 배지
                TemperatureBadge(temperature: viewModel.recipe.brewingTemperature)
                    .padding(.top)
                
                // 기본 정보 섹션
                BasicInfoSection(viewModel: viewModel)
                
                // 추출 설정 섹션
                BrewingSettingsSection(viewModel: viewModel)
                
                if viewModel.recipe.steps.isEmpty == false {
                    // 추출 단계 섹션
                    BrewingStepsSection(steps: viewModel.recipe.steps)
                }
                
                // 메모 섹션
                if viewModel.recipe.notes.isEmpty == false {
                    NotesSection(notes: viewModel.recipe.notes)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        coordinator.pop()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(Color.Custom.darkBrown.color)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("수정") {
                        coordinator.push(.recipeEdit(viewModel.recipe))
                    }
                }
            }
            .padding()
        }
        .tint(Color.Custom.darkBrown.color)
        .onAppear {
            tabBarState.isVisible = false
        }
        .onDisappear {
            tabBarState.isVisible = true
        }
        .background(Color.Custom.primaryBackground.color)
        .navigationTitle(viewModel.recipe.title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Temperature Badge
private struct TemperatureBadge: View {
    let temperature: BrewingTemperature
    
    var body: some View {
        HStack {
            HStack(spacing: 8) {
                Image(systemName: temperature == .hot ? "flame.fill" : "snowflake")
                Text(temperature.displayName)
                    .font(.system(size: 14, weight: .semibold))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(temperature == .hot ? Color.Custom.warmTerracotta.color : Color.Custom.calmSky.color)
            )
            
            Spacer()
        }
    }
}

// MARK: - Basic Info Section
private struct BasicInfoSection: View {
    let viewModel: RecipeDetailViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "기본 정보")
            
            VStack(alignment: .leading, spacing: 12) {
                InfoRow(label: "바리스타", value: viewModel.recipe.baristaName)
                InfoRow(label: "원두", value: viewModel.recipe.coffeeBeans)
                InfoRow(label: "추출 도구", value: viewModel.recipe.brewingMethod.displayName)
            }
        }
        .modifier(CardModifier())
    }
}

// MARK: - Brewing Settings Section
private struct BrewingSettingsSection: View {
    let viewModel: RecipeDetailViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "추출 설정")
            
            VStack(alignment: .leading, spacing: 12) {
                RatioView(coffeeWeight: viewModel.recipe.coffeeWeight, waterWeight: viewModel.recipe.waterWeight)
                
                InfoRow(
                    label: "물 온도",
                    value: "\(viewModel.recipe.waterTemperature)°C", // specifier: "%.0f"
                    valueColor: .orange
                )
                
                InfoRow(label: "분쇄도", value: viewModel.recipe.grindSize)
                
                InfoRow(
                    label: "총 추출 시간",
                    value: "\(viewModel.recipe.totalBrewTime)초",
                    valueColor: .blue
                )
            }
        }
        .modifier(CardModifier())
    }
}

// MARK: - Ratio View
private struct RatioView: View {
    let coffeeWeight: Double
    let waterWeight: Double
    
    var body: some View {
        HStack {
            Text("커피 : 물")
                .foregroundColor(.gray)
                .font(.system(size: 15))
            
            Spacer()
            
            Text("\(coffeeWeight, specifier: "%.1f")g")
                .fontWeight(.semibold)
            
            Text(":")
                .foregroundColor(.gray)
            
            Text("\(waterWeight, specifier: "%.0f")ml")
                .fontWeight(.semibold)
        }
    }
}

// MARK: - Brewing Steps Section
private struct BrewingStepsSection: View {
    let steps: [BrewingStep]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "추출 단계")
            
            VStack(spacing: 12) {
                ForEach(
                    steps.sorted(by: { $0.pourNumber < $1.pourNumber }),
                    id: \.pourNumber
                ) { step in
                    StepCard(step: step)
                }
            }
        }
        .modifier(CardModifier())
    }
}

private struct StepCard: View {
    let step: BrewingStep
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("#\(step.pourNumber)")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color.Custom.darkBrown.color)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "drop.fill")
                        .foregroundColor(Color.Custom.darkBrown.color)
                    Text("\(Int(step.pourAmount))ml")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Color.Custom.darkBrown.color)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.Custom.lightBrown.color.opacity(0.2))
                )
            }
            
            HStack(spacing: 6) {
                Image(systemName: "clock.fill")
                    .font(.system(size: 14))
                    .foregroundColor(Color.Custom.darkBrown.color)
                Text("\(step.formattedTime)에 시작")
                    .font(.system(size: 14))
                    .foregroundColor(Color.Custom.darkBrown.color)
            }
            
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
    }
}

// MARK: - Notes Section
private struct NotesSection: View {
    let notes: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "메모")
            
            Text(notes)
                .font(.system(size: 15))
        }
        .modifier(CardModifier())
    }
}

// MARK: - Common Views
private struct SectionHeader: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.system(size: 20, weight: .bold))
    }
}

private struct InfoRow: View {
    let label: String
    let value: String
    var valueColor: Color = .primary
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.gray)
                .font(.system(size: 15))
            Spacer()
            Text(value)
                .foregroundColor(valueColor)
                .fontWeight(.medium)
        }
    }
}

// MARK: - Modifiers
private struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(16)
            .background(Color.Custom.secondaryBackground.color)
            .cornerRadius(16)
            .shadow(color: Color.Custom.darkBrown.color.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

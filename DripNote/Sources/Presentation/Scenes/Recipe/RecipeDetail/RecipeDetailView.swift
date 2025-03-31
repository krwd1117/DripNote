import SwiftUI
import SwiftData
import DripNoteDomain

public struct RecipeDetailView: View {
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
                
                // 추출 단계 섹션
                BrewingStepsSection(steps: viewModel.recipe.steps)
                
                // 메모 섹션
                if !viewModel.recipe.notes.isEmpty {
                    NotesSection(notes: viewModel.recipe.notes)
                }
            }
            .padding()
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle(viewModel.recipe.title)
        .navigationBarTitleDisplayMode(.inline)
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
                    .fill(temperature == .hot ? Color.red : Color.blue)
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
                    .foregroundColor(.accentColor)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "drop.fill")
                        .foregroundColor(.blue)
                    Text("\(Int(step.pourAmount))ml")
                        .foregroundColor(.blue)
                        .fontWeight(.semibold)
                }
            }
            
            HStack {
                Image(systemName: "clock")
                    .foregroundColor(.gray)
                Text("\(step.formattedTime)에 시작")
                    .foregroundColor(.gray)
            }
            .font(.system(size: 14))
            
            if !step.desc.isEmpty {
                Text(step.desc)
                    .font(.system(size: 15))
                    .padding(.top, 4)
            }
        }
        .padding()
        .background(Color(uiColor: .systemBackground))
        .cornerRadius(12)
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
            .background(Color(uiColor: .systemBackground))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

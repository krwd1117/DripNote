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
                // 기본 정보 섹션
                BasicInfoSection(viewModel: viewModel)
                
                // 추출 설정 섹션
                BrewingSettingsSection(viewModel: viewModel)
                
                // 추출 단계 섹션
                BrewingStepsSection(steps: viewModel.steps)
                
                // 메모 섹션
                if let notes = viewModel.notes, !notes.isEmpty {
                    NotesSection(notes: notes)
                }
            }
            .padding()
        }
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Basic Info Section
private struct BasicInfoSection: View {
    let viewModel: RecipeDetailViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("기본 정보")
                .font(.title2)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("바리스타")
                        .foregroundColor(.gray)
                    Spacer()
                    Text(viewModel.baristaName)
                }
                
                HStack {
                    Text("원두")
                        .foregroundColor(.gray)
                    Spacer()
                    Text(viewModel.coffeeBeans)
                }
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Brewing Settings Section
private struct BrewingSettingsSection: View {
    let viewModel: RecipeDetailViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("추출 설정")
                .font(.title2)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("커피 : 물 비율")
                        .foregroundColor(.gray)
                    Spacer()
                    Text("\(viewModel.coffeeWeight, specifier: "%.1f")g : \(viewModel.waterWeight, specifier: "%.0f")ml")
                }
                
                HStack {
                    Text("물 온도")
                        .foregroundColor(.gray)
                    Spacer()
                    Text("\(viewModel.waterTemperature, specifier: "%.0f")°C")
                }
                
                HStack {
                    Text("분쇄도")
                        .foregroundColor(.gray)
                    Spacer()
                    Text(viewModel.grindSize)
                }
                
                HStack {
                    Text("총 추출 시간")
                        .foregroundColor(.gray)
                    Spacer()
                    Text("\(viewModel.totalBrewTime)초")
                }
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Brewing Steps Section
private struct BrewingStepsSection: View {
    let steps: [BrewingStep]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("추출 단계")
                .font(.title2)
                .fontWeight(.bold)
            
            ForEach(
                steps.sorted(by: { $0.pourNumber < $1.pourNumber }),
                id: \.pourNumber
            ) { step in
                StepCard(step: step)
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

private struct StepCard: View {
    let step: BrewingStep
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("단계 \(step.pourNumber)")
                    .font(.headline)
                Spacer()
                Text("\(Int(step.pourAmount))ml")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
            
            Text("\(step.formattedTime)에 시작")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text(step.desc)
                .font(.body)
        }
        .padding()
        .background(Color(uiColor: .systemBackground))
        .cornerRadius(8)
    }
}

// MARK: - Notes Section
fileprivate struct NotesSection: View {
    let notes: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("메모")
                .font(.title2)
                .fontWeight(.bold)
            
            Text(notes)
                .font(.body)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

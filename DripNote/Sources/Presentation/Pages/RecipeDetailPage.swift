import SwiftUI

struct RecipeDetailPage: View {
    @StateObject var viewModel: RecipeDetailViewModel
    
    // For navigation to timer (to be implemented with Coordinator)
    var onStartTimer: (String) -> Void
    
    init(recipeId: String, onStartTimer: @escaping (String) -> Void, repository: RecipeRepository) {
        _viewModel = StateObject(wrappedValue: RecipeDetailViewModel(recipeId: recipeId, repository: repository))
        self.onStartTimer = onStartTimer
    }

    var body: some View {
        ZStack {
            Color.backgroundPrimary.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if let recipe = viewModel.recipe {
                        // Main Image & Title (from design spec)
                        Image("coffee_beans_background") // Placeholder image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 250)
                            .clipped()
                            .cornerRadius(12)
                            .padding(.bottom, 10)
                        
                        Text(recipe.title)
                            .font(.appTitle)
                            .foregroundColor(.textPrimary)
                            .padding(.horizontal)
                        
                        // Core Info Summary (Organism - to be created)
                        HStack {
                            VStack(alignment: .leading) {
                                Text("총 추출 시간: \(String(format: "%.1f", recipe.totalBrewTime))초")
                                    .font(.appBody)
                                    .foregroundColor(.textSecondary)
                                Text("물 온도: \(String(format: "%.1f", recipe.waterTemperature))°C")
                                    .font(.appBody)
                                    .foregroundColor(.textSecondary)
                            }
                            Spacer()
                            // Rating / Yield (placeholder)
                            Text("평점: ★★★★☆")
                                .font(.appBody)
                                .foregroundColor(.accentOrange)
                        }
                        .padding(.horizontal)

                        Divider().background(Color.backgroundSecondary)
                        
                        // Brewing Steps (Organism - to be created)
                        VStack(alignment: .leading, spacing: 10) {
                            Text("추출 단계")
                                .font(.appHeadline)
                                .foregroundColor(.textPrimary)
                                .padding(.horizontal)
                            
                            ForEach(recipe.steps) { step in
                                Text("단계 \(step.pourTime)초: \(step.description)")
                                    .font(.appBody)
                                    .foregroundColor(.textPrimary)
                                    .padding(.horizontal)
                            }
                        }
                        
                        // Notes
                        VStack(alignment: .leading, spacing: 10) {
                            Text("메모")
                                .font(.appHeadline)
                                .foregroundColor(.textPrimary)
                                .padding(.horizontal)
                            Text(recipe.notes)
                                .font(.appBody)
                                .foregroundColor(.textSecondary)
                                .padding(.horizontal)
                        }
                    } else {
                        ProgressView()
                    }
                }
                .padding(.vertical)
            }
            
            VStack {
                Spacer()
                Button(action: {
                    if let recipeId = viewModel.recipe?.id.uuidString {
                        onStartTimer(recipeId)
                    }
                }) {
                    Text("브루잉 타이머 시작")
                        .font(.appHeadline)
                        .foregroundColor(.textPrimary)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentOrange)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(viewModel.recipe?.title ?? "레시피 상세")
                    .font(.appHeadline)
                    .foregroundColor(.textPrimary)
            }
        }
    }
}

// For Preview
struct RecipeDetailPage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView { // Wrap in NavigationView for toolbar preview
            RecipeDetailPage(recipeId: UUID().uuidString, onStartTimer: { _ in }, repository: RecipeDetailViewModel.MockRecipeRepository())
        }
    }
}

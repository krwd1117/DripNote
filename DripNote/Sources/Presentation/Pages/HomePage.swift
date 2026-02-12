import SwiftUI

struct HomePage: View {
    @StateObject var viewModel: HomeViewModel
    
    // For navigation to detail page (to be implemented with Coordinator)
    var onRecipeSelect: (String) -> Void
    
    init(onRecipeSelect: @escaping (String) -> Void, repository: RecipeRepository) {
        _viewModel = StateObject(wrappedValue: HomeViewModel(repository: repository))
        self.onRecipeSelect = onRecipeSelect
    }

    var body: some View {
        NavigationView { // For navigation stack within the tab
            ZStack {
                Color.backgroundPrimary.edgesIgnoringSafeArea(.all) // Full screen background

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Search Bar (Molecule or Organism - TBD)
                        Text("Search Bar Placeholder")
                            .font(.appHeadline)
                            .foregroundColor(.textPrimary)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.backgroundSecondary)
                            .cornerRadius(12)
                        
                        // Categories (Organism)
                        Text("Categories Placeholder")
                            .font(.appHeadline)
                            .foregroundColor(.textPrimary)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.backgroundSecondary)
                            .cornerRadius(12)

                        // Recommended Recipes (Organism)
                        VStack(alignment: .leading) {
                            Text("추천 레시피")
                                .font(.appHeadline)
                                .foregroundColor(.textPrimary)
                                .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(viewModel.recommendedRecipes) { recipe in
                                        RecipeCard(
                                            title: recipe.title,
                                            baristaName: recipe.baristaName,
                                            coffeeBeans: recipe.coffeeBeans,
                                            imageUrl: recipe.coffeeBeansStoreURL?.ko // Using ko url for demo
                                        )
                                        .frame(width: 200)
                                        .onTapGesture {
                                            onRecipeSelect(recipe.id.uuidString)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        // Recent Brewing History (Organism)
                        VStack(alignment: .leading) {
                            Text("최근 추출 기록")
                                .font(.appHeadline)
                                .foregroundColor(.textPrimary)
                                .padding(.horizontal)
                            
                            ForEach(viewModel.recentBrewings) { recipe in
                                Text(recipe.title)
                                    .font(.appBody)
                                    .foregroundColor(.textPrimary)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.backgroundSecondary)
                                    .cornerRadius(12)
                                    .padding(.horizontal)
                                    .onTapGesture {
                                        onRecipeSelect(recipe.id.uuidString)
                                    }
                            }
                        }
                    }
                    .padding(.vertical, 20)
                }
            }
            .navigationBarHidden(true) // Hide default navigation bar
        }
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        // Mock repository for preview
        let mockRepository = RecipeDetailViewModel.MockRecipeRepository()
        HomePage(onRecipeSelect: { _ in }, repository: mockRepository)
    }
}

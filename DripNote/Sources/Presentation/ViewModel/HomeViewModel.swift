import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @Published var recommendedRecipes: [BrewingRecipe] = []
    @Published var recentBrewings: [BrewingRecipe] = [] // Assuming recent brewings are also recipes
    
    private let repository: RecipeRepository // Assuming injected
    private var cancellables = Set<AnyCancellable>()

    init(repository: RecipeRepository) {
        self.repository = repository
        loadData()
    }

    func loadData() {
        Task { @MainActor in
            do {
                let allRecipes = try await repository.fetchRecipes()
                // For demo, just use all recipes as recommended/recent
                self.recommendedRecipes = allRecipes.shuffled()
                self.recentBrewings = allRecipes.sorted(by: { $0.id.uuidString > $1.id.uuidString }) // Simple sort for recent
            } catch {
                print("Error loading home data: \(error)")
            }
        }
    }
}

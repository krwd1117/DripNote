import SwiftUI
import Combine

// Assuming RecipeRepository is defined in Domain layer
protocol RecipeRepository {
    func fetchRecipes() async throws -> [BrewingRecipe]
    func createRecipe(_ recipe: BrewingRecipe) async throws
    func updateRecipe(_ recipe: BrewingRecipe) async throws
    func deleteRecipe(_ recipe: BrewingRecipe) async throws
}

class RecipeCoordinator: ObservableObject {
    enum Destination: Identifiable, Hashable {
        case recipeDetail(recipeId: String)
        case brewTimer(recipeId: String)
        
        var id: String {
            switch self {
            case .recipeDetail(let recipeId): return "recipeDetail_\(recipeId)"
            case .brewTimer(let recipeId): return "brewTimer_\(recipeId)"
            }
        }
    }
    
    @Published var path = NavigationPath()
    
    // Dependencies
    private let repository: RecipeRepository
    
    init(repository: RecipeRepository) {
        self.repository = repository
    }

    // Navigation actions
    func showRecipeDetail(recipeId: String) {
        path.append(Destination.recipeDetail(recipeId: recipeId))
    }
    
    func showBrewTimer(recipeId: String) {
        path.append(Destination.brewTimer(recipeId: recipeId))
    }
    
    @ViewBuilder
    func build(destination: Destination) -> some View {
        switch destination {
        case .recipeDetail(let recipeId):
            RecipeDetailPage(recipeId: recipeId, onStartTimer: showBrewTimer, repository: repository)
        case .brewTimer(let recipeId):
            BrewTimerPage(recipeId: recipeId)
        }
    }
}

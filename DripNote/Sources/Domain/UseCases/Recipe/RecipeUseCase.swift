import Foundation

public protocol RecipeUseCase {
    func fetchRecipes() async throws -> [BrewingRecipe]
    func createRecipe(_ recipe: BrewingRecipe) async throws
    func updateRecipe(_ recipe: BrewingRecipe) async throws
    func deleteRecipe(_ recipe: BrewingRecipe) async throws
}

public final class DefaultRecipeUseCase: RecipeUseCase {
    private let repository: RecipeRepository
    
    public init(repository: RecipeRepository) {
        self.repository = repository
    }
    
    public func fetchRecipes() async throws -> [BrewingRecipe] {
        try await repository.fetchRecipes()
    }
    
    public func createRecipe(_ recipe: BrewingRecipe) async throws {
        try await repository.createRecipe(recipe)
    }
    
    public func updateRecipe(_ recipe: BrewingRecipe) async throws {
        try await repository.updateRecipe(recipe)
    }
    
    public func deleteRecipe(_ recipe: BrewingRecipe) async throws {
        try await repository.deleteRecipe(recipe)
    }
} 
import Foundation

public protocol FirestoreRecipeUseCase {
    func fetchRecipes() async throws -> [BaristaBrewingRecipe]
    func createRecipe(_ recipe: BaristaBrewingRecipe) async throws
}

public final class DefaultFirestoreRecipeUseCase: FirestoreRecipeUseCase {
    private let repository: FirestoreRecipeRepository
    
    public init(repository: FirestoreRecipeRepository) {
        self.repository = repository
    }
    
    public func fetchRecipes() async throws -> [BaristaBrewingRecipe] {
        try await repository.fetchBaristaBrewingRecipes()
    }
    
    public func createRecipe(_ recipe: BaristaBrewingRecipe) async throws {
        try await repository.createBaristaBrewingRecipe(recipe)
    }
}

import Foundation

public protocol RecipeRepository {
    func fetchRecipes() async throws -> [BrewingRecipe]
    func createRecipe(_ recipe: BrewingRecipe) async throws
    func updateRecipe(_ recipe: BrewingRecipe) async throws
    func deleteRecipe(_ recipe: BrewingRecipe) async throws
}

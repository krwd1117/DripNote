import Foundation

public protocol FirestoreRecipeRepository {
    func fetchBaristaBrewingRecipes() async throws -> [BaristaBrewingRecipe]
    func createBaristaBrewingRecipe(_ recipe: BaristaBrewingRecipe) async throws
}

import Foundation
import SwiftData
import DripNoteDomain

public final class LocalBrewingRecipeRepositoryImpl: RecipeRepository {
    private let dataSource: LocalBrewingRecipeDataSource

    public init(dataSource: LocalBrewingRecipeDataSource) {
        self.dataSource = dataSource
    }

    public func fetchRecipes() async throws -> [BrewingRecipe] {
        try dataSource.fetchAll()
    }

    public func createRecipe(_ recipe: BrewingRecipe) async throws {
        try dataSource.insert(recipe)
    }

    public func deleteRecipe(_ recipe: BrewingRecipe) async throws {
        try dataSource.delete(recipe)
    }

    public func updateRecipe(_ recipe: BrewingRecipe) async throws {
        try dataSource.insert(recipe)
    }
}

import Foundation
import SwiftData
import DripNoteDomain

public final class RecipeRepositoryImpl: RecipeRepository {
    private let modelContext: ModelContext
    
    public init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    public func fetchRecipes() async throws -> [BrewingRecipe] {
        let descriptor = FetchDescriptor<BrewingRecipe>()
        return try modelContext.fetch(descriptor)
    }
    
    public func createRecipe(_ recipe: BrewingRecipe) async throws {
        modelContext.insert(recipe)
        try modelContext.save()
    }
    
    public func updateRecipe(_ recipe: BrewingRecipe) async throws {
        try modelContext.save()
    }
    
    public func deleteRecipe(_ recipe: BrewingRecipe) async throws {
        modelContext.delete(recipe)
        try modelContext.save()
    }
} 

import SwiftData
import DripNoteDomain

public final class LocalBrewingRecipeDataSource {
    private let modelContext: ModelContext

    public init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    public func fetchAll() throws -> [BrewingRecipe] {
        try modelContext.fetch(FetchDescriptor<BrewingRecipe>())
    }

    public func insert(_ recipe: BrewingRecipe) throws {
        modelContext.insert(recipe)
        try modelContext.save()
    }

    public func delete(_ recipe: BrewingRecipe) throws {
        modelContext.delete(recipe)
        try modelContext.save()
    }
}

import SwiftUI
import SwiftData
import DripNoteDomain

public final class RecipeDetailViewModel: ObservableObject {
    // MARK: - Properties
    @Published private(set) var recipe: BrewingRecipe
    
    private var modelContext: ModelContext
    
    // MARK: - Initialization
    public init(recipe: BrewingRecipe, modelContext: ModelContext) {
        self.recipe = recipe
        self.modelContext = modelContext
    }
    
    // MARK: - Computed Properties
    var title: String {
        recipe.title
    }
    
    var baristaName: String {
        recipe.baristaName
    }
    
    var coffeeBeans: String {
        recipe.coffeeBeans
    }
    
    var coffeeWeight: Double {
        recipe.coffeeWeight
    }
    
    var waterWeight: Double {
        recipe.waterWeight
    }
    
    var waterTemperature: Double {
        recipe.waterTemperature
    }
    
    var grindSize: String {
        recipe.grindSize
    }
    
    var totalBrewTime: Int {
        Int(recipe.totalBrewTime)
    }
    
    var steps: [BrewingStep] {
        recipe.steps
    }
    
    var notes: String? {
        recipe.notes
    }
} 

import SwiftUI
import SwiftData
import DripNoteDomain

public final class RecipeDetailViewModel: ObservableObject {
    // MARK: - Properties
    @Published private(set) var recipe: BrewingRecipe
    
    // MARK: - Initialization
    public init(recipe: BrewingRecipe) {
        self.recipe = recipe
    }
} 

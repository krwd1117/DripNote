import Foundation
import DripNoteDomain

@MainActor
final class BaristaRecipeDetailViewModel: ObservableObject {
    @Published private(set) var recipe: BaristaBrewingRecipe?
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    
    init(recipe: BaristaBrewingRecipe) {
        self.recipe = recipe
    }
} 

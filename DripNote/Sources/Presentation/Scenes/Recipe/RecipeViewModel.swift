import SwiftUI
import SwiftData
import DripNoteDomain

@MainActor
public final class RecipeViewModel: ObservableObject {
    
    // MARK: - Properties
    @Published var recipes: [BrewingRecipe] = []
    @Published var navigationPath = NavigationPath()
    
    private let useCase: RecipeUseCase
    
    // MARK: - Initialization
    public init(useCase: RecipeUseCase) {
        self.useCase = useCase
    }
    
    // MARK: - Private Methods
    public func fetchRecipes() async {
        do {
            recipes = try await useCase.fetchRecipes()
        } catch {
            print("Error fetching recipes: \(error)")
        }
    }
    
    // MARK: - Public Methods
    public func deleteRecipe(_ recipe: BrewingRecipe) {
        Task {
            do {
                try await useCase.deleteRecipe(recipe)
                await fetchRecipes()
            } catch {
                print("Error deleting recipe: \(error)")
            }
        }
    }
}

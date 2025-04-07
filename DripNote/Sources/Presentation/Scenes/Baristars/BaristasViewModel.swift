import Foundation
import DripNoteDomain

@MainActor
final class BaristasViewModel: ObservableObject {
    @Published var recipes: [BaristaBrewingRecipe] = []
    @Published var isLoading = true
    @Published private var error: Error?
    
    private let useCase: FirestoreRecipeUseCase
    
    init(useCase: FirestoreRecipeUseCase) {
        self.useCase = useCase
    }
    
    func fetchRecipes() async {
        isLoading = true
        
        do {
            recipes = try await useCase.fetchRecipes()
        } catch {
            print("Error: \(error)")
        }
        
        isLoading = false
    }
}

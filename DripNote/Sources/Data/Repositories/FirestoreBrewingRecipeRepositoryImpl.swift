import Foundation
import FirebaseFirestore
import DripNoteDomain

public final class FirestoreBrewingRecipeRepositoryImpl: FirestoreRecipeRepository {
    private let dataSource = FirestoreBrewingRecipeDataSource()
    
    public init() {}
    
    public func fetchBaristaBrewingRecipes() async throws -> [BaristaBrewingRecipe] {
        let recipes = try await dataSource.fetchBaristasBrewingRecipes()
        return recipes
    }
    
    public func createBaristaBrewingRecipe(_ recipe: BaristaBrewingRecipe) async throws {
        try await dataSource.createBaristaBrewingRecipe(recipe: recipe)
    }
    
    private func decodeSteps(from data: [[String: Any]]) throws -> [BrewingStep] {
        return data.map { stepData in
            return BrewingStep(
                pourNumber: stepData["pourNumber"] as? Int ?? 0,
                pourAmount: stepData["pourAmount"] as? Double ?? 0.0,
                pourTime: stepData["pourTime"] as? Double ?? 0.0,
                desc: stepData["desc"] as? String ?? ""
            )
        }
    }
}

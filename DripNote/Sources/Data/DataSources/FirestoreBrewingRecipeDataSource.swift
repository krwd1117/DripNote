import Foundation

import FirebaseFirestore
import DripNoteDomain

final class FirestoreBrewingRecipeDataSource {
    private let db = Firestore.firestore()

    func fetchBaristasBrewingRecipes() async throws -> [BaristaBrewingRecipe] {
        let snapshot = try await db.collection("barista_brewing_recipes").getDocuments()
        return try snapshot.documents.compactMap {
            try $0.data(as: BaristaBrewingRecipe.self)
        }
    }

    func fetchSteps(for id: String) async throws -> [BaristaBrewingStep] {
        let snapshot = try await db.collection("barista_brewing_recipes")
            .document(id)
            .collection("steps").getDocuments()

        return try snapshot.documents.compactMap {
            try $0.data(as: BaristaBrewingStep.self)
        }
    }
    
    func createBaristaBrewingRecipe(
        recipe: BaristaBrewingRecipe
    ) async throws {
        let documentRef = db.collection("barista_brewing_recipes").document(recipe.id)
        try documentRef.setData(from: recipe)

        for step in recipe.steps {
            let stepRef = documentRef.collection("steps").document()
            try stepRef.setData(from: step)
        }
    }
}

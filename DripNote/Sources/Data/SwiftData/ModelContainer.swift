import Foundation
import SwiftData
import DripNoteDomain

public final class ModelContainerFactory {
    public static func create() throws -> ModelContainer {
        let schema = Schema([
            BrewingRecipe.self,
            BrewingStep.self
        ])
        
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            allowsSave: true
        )
        
        return try ModelContainer(
            for: schema,
            configurations: [modelConfiguration]
        )
    }
} 

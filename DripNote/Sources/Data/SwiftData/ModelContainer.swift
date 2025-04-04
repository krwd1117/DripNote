import Foundation
import SwiftData
import DripNoteDomain

public final class ModelContainerFactory {
    public static func create() throws -> ModelContainer {
        let schema = Schema([
            BrewingRecipe.self,
            BrewingStep.self
        ])
        
        let isPreview = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
        if isPreview {
            print("🛠 [Preview] Initializing in-memory ModelContainer")
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            return try ModelContainer(
                for: schema,
                configurations: config
            )
        } else {
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
} 

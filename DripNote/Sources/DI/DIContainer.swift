import DripNoteDomain
import DripNoteData

import Foundation
import SwiftData

public final class DIContainer {
    public static let shared = DIContainer()
    
    private var dependencies: [String: Any] = [:]
    
    private init() {}
    
    public func register<T>(_ type: T.Type, dependency: @escaping () -> T) {
        let key = String(describing: type)
        dependencies[key] = dependency
    }
    
    public func register<T>(_ type: T.Type, instance: Any) {
        let key = String(describing: type)
        dependencies[key] = instance
    }
    
    public func resolve<T>(_ type: T.Type) -> T {
        guard let instance = dependencies[String(describing: type)] as? T else {
            fatalError("No dependency found for \(type)")
        }
        return instance
    }
    
    @MainActor public func build(modelContext: ModelContext) {
        registerRepositories(modelContext: modelContext)
        registerUseCases()
    }
    
    public func reset() {
        dependencies.removeAll()
    }
}

// MARK: - Registration
private extension DIContainer {
    @MainActor func registerRepositories(modelContext: ModelContext) {
        let dataSource = LocalBrewingRecipeDataSource(modelContext: modelContext)
        let repository = LocalBrewingRecipeRepositoryImpl(dataSource: dataSource)
        register(RecipeUseCase.self, instance: DefaultRecipeUseCase(repository: repository))
        
        let firebaseBrewingrepository = FirestoreBrewingRecipeRepositoryImpl()
        register(FirestoreRecipeUseCase.self, instance: DefaultFirestoreRecipeUseCase(repository: firebaseBrewingrepository))
    }
    
    func registerUseCases() {}
}

import SwiftUI
import SwiftData
import DripNoteCore
import DripNoteDomain
import DripNoteDI

public final class RecipeCoordinator: Coordinator {
    public enum Route: Hashable {
        case recipeCreate
        case recipeDetail(BrewingRecipe)
        case recipeEdit(BrewingRecipe)
    }
    
    @Published public var navigationPath = NavigationPath()
    
    var modelContext: ModelContext
    
    @MainActor
    public init() {
        modelContext = try! ModelContainer(for: BrewingRecipe.self).mainContext
    }
    
    public func push(_ route: Route) {
        navigationPath.append(route)
    }
    
    public func pop() {
        guard !navigationPath.isEmpty else { return }
        navigationPath.removeLast()
    }
    
    @ViewBuilder
    public func view(for route: Route) -> some View {
        switch route {
        case .recipeCreate:
            RecipeFormView(recipe: nil, useCase: DIContainer.shared.resolve(RecipeUseCase.self))
        case .recipeDetail(let recipe):
            let viewModel = RecipeDetailViewModel(recipe: recipe)
            RecipeDetailView(viewModel: viewModel)
        case .recipeEdit(let recipe):
            RecipeFormView(recipe: recipe, useCase: DIContainer.shared.resolve(RecipeUseCase.self))
        }
    }
}

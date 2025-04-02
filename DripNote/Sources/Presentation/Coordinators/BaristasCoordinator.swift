import SwiftUI
import DripNoteCore
import DripNoteDomain

public final class BaristasCoordinator: Coordinator {
    public enum Route: Hashable {
        case detail(BaristaBrewingRecipe)
        
        public static func == (lhs: Route, rhs: Route) -> Bool {
            switch (lhs, rhs) {
            case (.detail(let l), .detail(let r)):
                return l.id == r.id
            }
        }

        public func hash(into hasher: inout Hasher) {
            switch self {
            case .detail(let recipe):
                hasher.combine(recipe.id)
            }
        }
    }
    
    @Published public var navigationPath = NavigationPath()
    
    public init() {}
    
    public func push(_ route: Route) {
        navigationPath.append(route)
    }
    
    @ViewBuilder
    public func view(for route: Route) -> some View {
        switch route {
        case .detail(let recipe):
            BaristaRecipeDetailView(recipe: recipe)
        }
    }
} 

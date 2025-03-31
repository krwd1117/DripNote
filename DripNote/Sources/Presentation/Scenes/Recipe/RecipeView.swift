import DripNoteDomain
import DripNoteDI

import SwiftUI
import SwiftData

public struct RecipeView: View {
    @EnvironmentObject var tabBarState: TabBarState
    @ObservedObject private var coordinator: RecipeCoordinator
    @StateObject private var viewModel: RecipeViewModel
    
    public init(coordinator: RecipeCoordinator) {
        self.coordinator = coordinator
        self._viewModel = StateObject(
            wrappedValue: RecipeViewModel(useCase: DIContainer.shared.resolve(RecipeUseCase.self))
        )
    }
    
    public var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            ZStack {
                Group {
                    if viewModel.recipes.isEmpty {
                        CustomEmptyView(
                            title: "저장된 레시피가 없어요",
                            message: "새 레시피를 추가해 나만의 커피를 기록해보세요.",
                            systemImageName: "cup.and.saucer"
                        )
                    } else {
                        List {
                            ForEach(viewModel.recipes) { recipe in
                                Button {
                                    coordinator.push(.recipeDetail(recipe))
                                } label: {
                                    RecipeRow(recipe: recipe)
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    Button(role: .destructive) {
                                        viewModel.deleteRecipe(recipe)
                                    } label: {
                                        Label("삭제", systemImage: "trash")
                                    }
                                    
                                    Button {
                                        coordinator.push(.recipeEdit(recipe))
                                    } label: {
                                        Label("수정", systemImage: "pencil")
                                    }
                                    .tint(.orange)
                                }
                            }
                        }
                    }
                }
                .navigationTitle("레시피")
                .navigationDestination(for: RecipeCoordinator.Route.self) { route in
                    coordinator.view(for: route)
                }
                .onAppear {
                    tabBarState.isVisible = true
                }
                .task {
                    await viewModel.fetchRecipes()
                }
            }
        }
    }
}

// MARK: - Recipe Row
private struct RecipeRow: View {
    let recipe: BrewingRecipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(recipe.title)
                .font(.headline)
            Text(recipe.baristaName)
                .font(.subheadline)
                .foregroundColor(.gray)
            Text("\(recipe.coffeeWeight, specifier: "%.0f")g")
                .font(.caption)
                .foregroundColor(.gray)
            Text("\(recipe.waterWeight, specifier: "%.0f")ml")
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    RecipeView(coordinator: RecipeCoordinator())
}

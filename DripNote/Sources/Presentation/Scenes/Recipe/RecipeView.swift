import DripNoteDomain
import DripNoteDI

import SwiftUI
import SwiftData
import Foundation

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
            Group {
                if viewModel.recipes.isEmpty {
                    CustomEmptyView(
                        title: String(localized: "Recipe.Empty.Title"),
                        message: String(localized: "Recipe.Empty.Message"),
                        systemImageName: "cup.and.saucer"
                    )
                } else {
                    ScrollView {
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(), spacing: 16),
                                GridItem(.flexible(), spacing: 16)
                            ],
                            spacing: 16
                        ) {
                            ForEach(viewModel.recipes) { recipe in
                                Button {
                                    coordinator.push(.recipeDetail(recipe))
                                } label: {
                                    RecipeRow(recipe: recipe)
                                        .contextMenu {
                                            Button(role: .destructive) {
                                                viewModel.deleteRecipe(recipe)
                                            } label: {
                                                Label(String(localized: "Common.Delete"), systemImage: "trash")
                                            }
                                            
                                            Button {
                                                coordinator.push(.recipeEdit(recipe))
                                            } label: {
                                                Label(String(localized: "Common.Edit"), systemImage: "pencil")
                                            }
                                        }
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                    }
                    .background(Color.Custom.primaryBackground.color)
                }
            }
            .navigationTitle(String(localized: "Recipe.MyRecipe"))
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: RecipeCoordinator.Route.self) { route in
                coordinator.view(for: route)
                    .environmentObject(coordinator)
            }
            .tint(Color.Custom.accentBrown.color)
            .onAppear {
                tabBarState.isVisible = true
            }
            .task {
                await viewModel.fetchRecipes()
            }
        }
    }
}

// MARK: - Recipe Row
private struct RecipeRow: View {
    let recipe: BrewingRecipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 상단 아이콘 및 메소드
            HStack {
                Image(systemName: recipe.brewingTemperature == .hot ? "flame.fill" : "snowflake")
                    .foregroundStyle(recipe.brewingTemperature == .hot ? Color.Custom.warmTerracotta.color : Color.Custom.calmSky.color)
                    .font(.system(size: 18))
                
                Spacer()
                
                Text(recipe.brewingMethod.displayName)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.Custom.secondaryBackground.color)
                    .clipShape(Capsule())
            }
            
            // 제목 및 바리스타
            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.title)
                    .font(.system(size: 16, weight: .semibold))
                    .lineLimit(1)
                
                if recipe.baristaName.isEmpty == false {
                    Text(recipe.baristaName)
                        .font(.system(size: 12))
                        .foregroundColor(Color.Custom.darkBrown.color)
                }
            }
            
            Divider()
            
            // 추출 정보
            HStack(spacing: 12) {
                if recipe.totalBrewTime > 0 {
                    HStack(spacing: 4) {
                        Image(systemName: "timer")
                            .font(.system(size: 12))
                        Text(String(format: String(localized: "Recipe.Time.TotalTime"), Int(recipe.totalBrewTime)))
                            .font(.system(size: 12))
                    }
                    .foregroundColor(Color.Custom.darkBrown.color)
                }
                
                Text(String(format: String(localized: "Recipe.Weight.Ratio"), Int(recipe.coffeeWeight), Int(recipe.waterWeight)))
                    .font(.system(size: 12))
                    .foregroundColor(Color.Custom.darkBrown.color)
            }
        }
        .padding(16)
        .background(Color.Custom.secondaryBackground.color)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.Custom.darkBrown.color.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

#Preview(body: {
    let recipe = BrewingRecipe(
        id: UUID(),
        title: "레시피 제목",
        baristaName: "바리스타 이름",
        coffeeBeans: "원두",
        brewingMethod: .v60,
        brewingTemperature: .hot,
        coffeeWeight: 20,
        waterWeight: 200,
        waterTemperature: 93,
        grindSize: "27",
        steps: [
            .init(pourNumber: 1, pourAmount: 30, pourTime: 30, desc: "")
        ],
        notes: ""
    )
    RecipeRow(recipe: recipe)
})

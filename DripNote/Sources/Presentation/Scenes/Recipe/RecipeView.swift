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
                    RecipeGridView(coordinator: coordinator, viewModel: viewModel)
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

// MARK: - RecipeGrid View
fileprivate struct RecipeGridView: View {
    @ObservedObject private var coordinator: RecipeCoordinator
    @ObservedObject private var viewModel: RecipeViewModel
    
    init(coordinator: RecipeCoordinator, viewModel: RecipeViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
    }
    
    var body: some View {
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
                        RecipeGridCell(recipe: recipe)
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
    
    // MARK: RecipeGrid Cell
    private struct RecipeGridCell: View {
        @AppStorage("useMetricWeight") private var useMetricWeight: Bool = true
        @AppStorage("useMetricVolume") private var useMetricVolume: Bool = true
        @AppStorage("useMetricTemperature") private var useMetricTemperature: Bool = true
        
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
                    // 원두 양 : 물 양
                    Text(
                        String(
                            format: String(localized: "Recipe.Ratio.Format"),
                            useMetricWeight ? recipe.coffeeWeight : recipe.coffeeWeight.convertTo(to: .oz), String(localized: useMetricWeight ? "Unit.Gram" : "Unit.Oz"),
                            useMetricVolume ? recipe.waterWeight : recipe.waterWeight.convertTo(to: .floz), String(localized: useMetricVolume ? "Unit.Milliliter" : "Unit.Floz")
                        )
                    )
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
}

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
                                                    Label("삭제", systemImage: "trash")
                                                }
                                                
                                                Button {
                                                    coordinator.push(.recipeEdit(recipe))
                                                } label: {
                                                    Label("수정", systemImage: "pencil")
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
                .navigationTitle("나의 레시피")
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
                
                Text(recipe.baristaName)
                    .font(.system(size: 12))
                    .foregroundColor(Color.Custom.darkBrown.color)
            }
            
            Divider()
            
            // 추출 정보
            HStack(spacing: 12) {
                HStack(spacing: 4) {
                    Image(systemName: "timer")
                        .font(.system(size: 12))
                    Text("\(recipe.totalBrewTime, specifier: "%.0f")초")
                        .font(.system(size: 12))
                }
                .foregroundColor(Color.Custom.darkBrown.color)
                
                HStack(spacing: 4) {
                    Text("\(recipe.coffeeWeight, specifier: "%.0f")g")
                    Text(":")
                    Text("\(recipe.waterWeight, specifier: "%.0f")ml")
                }
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

//#Preview {
//    @StateObject var tabBarState: TabBarState = .init(isVisible: true)
//    
//    RecipeView(coordinator: RecipeCoordinator())
//        .environmentObject(tabBarState)
//}


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

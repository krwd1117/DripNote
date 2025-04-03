import SwiftUI
import DripNoteDomain
import DripNoteDI
import DripNoteThirdParty

public struct BaristasView: View {
    @ObservedObject private var coordinator: BaristasCoordinator
    @StateObject private var viewModel: BaristasViewModel
    
    public init(coordinator: BaristasCoordinator) {
        self.coordinator = coordinator
        self._viewModel = StateObject(
            wrappedValue: BaristasViewModel(useCase: DIContainer.shared.resolve(FirestoreRecipeUseCase.self))
        )
    }
    
    public var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            ZStack {
                Color.Custom.primaryBackground.color
                    .ignoresSafeArea()
                
                if viewModel.isLoading {
                    LoadingView(viewModel: viewModel)
                } else {
                    GridView(coordinator: coordinator, viewModel: viewModel)
                }
            }
            .navigationTitle(String(localized: "Barista.Title"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Loading View
fileprivate struct LoadingView: View {
    @ObservedObject var viewModel: BaristasViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(Color.Custom.accentBrown.color)
            
            Text("Barista.Loading")
                .font(.system(size: 14))
                .foregroundColor(Color.Custom.darkBrown.color)
        }
        .task {
            await viewModel.fetchRecipes()
        }
    }
}

// MARK: - Grid View
fileprivate struct GridView: View {
    @ObservedObject var coordinator: BaristasCoordinator
    @ObservedObject var viewModel: BaristasViewModel
    
    enum GridItemType: Identifiable {
        case recipe(BaristaBrewingRecipe)
        case ad(UUID)

        var id: String {
            switch self {
            case .recipe(let recipe): return recipe.id
            case .ad(let uuid): return uuid.uuidString
            }
        }
    }
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            let items: [GridItemType] = {
                var result: [GridItemType] = []
                for (index, recipe) in viewModel.recipes.enumerated() {
                    result.append(.recipe(recipe))
                    if (index + 1) % 3 == 0 {
                        result.append(.ad(UUID()))
                    }
                }
                return result
            }()
            
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(items) { item in
                    switch item {
                    case .recipe(let recipe):
                        Button {
                            coordinator.push(.detail(recipe))
                        } label: {
                            RecipeCard(recipe: recipe)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)

                    case .ad:
                        VStack {
                            NativeAdContainerView(backgroundColor: Color.Custom.secondaryBackground.color)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .cornerRadius(16)
                        .shadow(color: Color.Custom.darkBrown.color.opacity(0.05), radius: 4, x: 0, y: 2)
                        .gridCellColumns(2)
                    }
                }
            }
            .padding(16)
        }
        .scrollContentBackground(.hidden)
        .background(Color.Custom.primaryBackground.color)
        .tint(Color.Custom.darkBrown.color)
        .navigationDestination(for: BaristasCoordinator.Route.self) { route in
            coordinator.view(for: route)
        }
        .refreshable {
            await viewModel.fetchRecipes()
        }
    }
    
    private struct RecipeCard: View {
        let recipe: BaristaBrewingRecipe
        
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                // 상단: 레시피 제목과 좋아요
                HStack {
                    Text(recipe.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color.Custom.darkBrown.color)
                    
                    Spacer()
                }
                
                // 중간: 바리스타 이름과 원두
                VStack(alignment: .leading, spacing: 4) {
                    Text(recipe.baristaName)
                        .font(.system(size: 14))
                        .foregroundColor(Color.Custom.darkBrown.color)
                    
                    Text(recipe.coffeeBeans)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // 하단: 추출 도구와 온도
                HStack(spacing: 12) {
                    Label(
                        recipe.brewingMethod.displayName,
                        systemImage: "mug.fill"
                    )
                    
                    Label(
                        String(format: String(localized: "Recipe.Temperature.Format"),
                              Int(recipe.waterTemperature),
                              String(localized: "Unit.Celsius")),
                        systemImage: recipe.brewingTemperature == .hot ? "flame.fill" : "snowflake"
                    )
                    .foregroundColor(recipe.brewingTemperature == .hot ? Color.Custom.warmTerracotta.color : Color.Custom.calmSky.color)
                }
                .font(.system(size: 12))
                .foregroundColor(Color.Custom.darkBrown.color)
            }
            .padding(16)
            .background(Color.Custom.secondaryBackground.color)
            .cornerRadius(16)
            .shadow(color: Color.Custom.darkBrown.color.opacity(0.05), radius: 4, x: 0, y: 2)
        }
    }
}

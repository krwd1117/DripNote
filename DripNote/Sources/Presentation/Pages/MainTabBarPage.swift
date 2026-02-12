import SwiftUI

struct MainTabBarPage: View {
    @State private var selectedTab: TabItem = .home // Default to home
    @StateObject var recipeCoordinator: RecipeCoordinator // Inject RecipeCoordinator

    init(repository: RecipeRepository) {
        _recipeCoordinator = StateObject(wrappedValue: RecipeCoordinator(repository: repository))
    }

    var body: some View {
        NavigationStack(path: $recipeCoordinator.path) {
            TabView(selection: $selectedTab) {
                // Home tab
                HomePage(onRecipeSelect: recipeCoordinator.showRecipeDetail, repository: recipeCoordinator.repository)
                    .tag(TabItem.home)
                    .toolbar(.hidden, for: .navigationBar) // Hide default nav bar in Home

                // Other tabs
                Text("Beans Page")
                    .tag(TabItem.beans)
                Text("Stats Page")
                    .tag(TabItem.stats)
                Text("Settings Page")
                    .tag(TabItem.settings)
            }
            .accentColor(.accentOrange) // For default TabView selection tint
            .navigationDestination(for: RecipeCoordinator.Destination.self) { destination in
                recipeCoordinator.build(destination: destination)
            }
            
            // Bottom Navigation Bar
            VStack {
                Spacer()
                BottomNavBar(selectedTab: $selectedTab)
            }
        }
        .edgesIgnoringSafeArea(.bottom) // Extend background to cover nav bar area
    }
}

struct MainTabBarPage_Previews: PreviewProvider {
    static var previews: some View {
        // Mock repository for preview
        let mockRepository = RecipeDetailViewModel.MockRecipeRepository()
        MainTabBarPage(repository: mockRepository)
    }
}

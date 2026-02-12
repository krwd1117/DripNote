import SwiftUI

public struct MainContainer: View {
    @State private var selectedTab: TabItem = .myRecipes
    @StateObject private var tabBarState = TabBarState()
    @StateObject private var recipeCoordinator = RecipeCoordinator()
    @StateObject private var baristasCoordinator = BaristasCoordinator()
    @StateObject private var settingCoordinator = SettingsCoordinator()
    
    public init() {}
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                RecipeView(coordinator: recipeCoordinator)
                    .tag(TabItem.myRecipes)
                
                BaristasView(coordinator: baristasCoordinator)
                    .tag(TabItem.baristas)
                
                SettingsView(coordinator: settingCoordinator)
                    .tag(TabItem.settings)
            }
            
            if tabBarState.isVisible {
                CustomBottomTabBar(
                    selectedTab: $selectedTab,
                    onTapFloatingButton: {
                        if selectedTab == .myRecipes {
                            recipeCoordinator.push(.recipeCreate)
                        }
                    }
                )
                .transition(.move(edge: .bottom))
                .animation(.easeInOut, value: tabBarState.isVisible)
                .ignoresSafeArea(.keyboard)
            }
        }
        .environmentObject(tabBarState)
        .ignoresSafeArea(.keyboard)
    }
}

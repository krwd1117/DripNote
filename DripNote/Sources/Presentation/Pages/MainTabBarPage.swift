import SwiftUI

struct MainTabBarPage: View {
    @State private var selectedTab: TabItem = .home // Default to home

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomePage()
                    .tag(TabItem.home)
                Text("Beans Page")
                    .tag(TabItem.beans)
                Text("Stats Page")
                    .tag(TabItem.stats)
                Text("Settings Page")
                    .tag(TabItem.settings)
            }
            .accentColor(.accentOrange) // For default TabView selection tint
            
            BottomNavBar(selectedTab: $selectedTab)
                .padding(.bottom, 0)
        }
        .edgesIgnoringSafeArea(.bottom) // Extend background to cover nav bar area
    }
}

struct MainTabBarPage_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.backgroundPrimary.edgesIgnoringSafeArea(.all)
            MainTabBarPage()
        }
    }
}

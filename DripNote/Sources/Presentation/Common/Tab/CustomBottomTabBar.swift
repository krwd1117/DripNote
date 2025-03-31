import SwiftUI

public struct CustomBottomTabBar: View {
    @Binding var selectedTab: TabItem
    let onTapFloatingButton: () -> Void
    
    public init(
        selectedTab: Binding<TabItem>,
        onTapFloatingButton: @escaping () -> Void
    ) {
        self._selectedTab = selectedTab
        self.onTapFloatingButton = onTapFloatingButton
    }
    
    public var body: some View {
        ZStack {
            // 메인 탭바
            HStack {
                ForEach(TabItem.allCases, id: \.rawValue) { tab in
                    tabButton(tab: tab)
                        .frame(maxWidth: .infinity)
                }
                
                if selectedTab.showsFloatingButton {
                    Spacer()
                        .frame(width: 60)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 14)
            .padding(.bottom, 14)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(uiColor: .systemBackground))
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -5)
            }
            .padding(.horizontal, 8)
            
            // 플로팅 버튼
            if selectedTab.showsFloatingButton {
                HStack {
                    Spacer()
                    Button(action: onTapFloatingButton) {
                        ZStack {
                            Circle()
                                .fill(Color.Custom.accentBrown.color)
                                .frame(width: 60, height: 60)
                                .shadow(color: Color.Custom.darkBrown.color.opacity(0.2), radius: 5)
                            
                            Image(systemName: "plus")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(.white)
                        }
                    }
                    .offset(y: -30)
                    .padding(.trailing, 20)
                }
            }
        }
    }
    
    @MainActor
    private func tabButton(tab: TabItem) -> some View {
        Button {
            withAnimation() {
                selectedTab = tab
            }
        } label: {
            VStack(spacing: 4) {
                Image(systemName: selectedTab == tab ? tab.selectedIcon : tab.icon)
                    .font(.system(size: 24))
                
                Text(tab.title)
                    .font(.system(size: 12))
            }
            .foregroundColor(selectedTab == tab ? Color.Custom.darkBrown.color : Color.Custom.darkBrown.color.opacity(0.5))
        }
    }
}

#Preview {
    CustomBottomTabBar(
        selectedTab: .constant(.myRecipes),
        onTapFloatingButton: {}
    )
}

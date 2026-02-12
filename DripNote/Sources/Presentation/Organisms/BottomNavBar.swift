import SwiftUI

struct BottomNavBar: View {
    @Binding var selectedTab: TabItem // TabItem is Atom
    
    var body: some View {
        HStack {
            Spacer()
            ForEach(TabItem.allCases) { item in
                Button(action: {
                    selectedTab = item
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: item.iconName)
                            .font(.body)
                        Text(item.title)
                            .font(.caption)
                    }
                    .foregroundColor(selectedTab == item ? .accentOrange : .textSecondary)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
                }
            }
            Spacer()
        }
        .background(Color.backgroundSecondary)
        .cornerRadius(20) // Rounded corners for the bar itself
        .padding(.horizontal)
        .shadow(color: Color.backgroundPrimary.opacity(0.3), radius: 5, x: 0, y: -2)
    }
}

struct BottomNavBar_Previews: PreviewProvider {
    @State static var selectedTab: TabItem = .home

    static var previews: some View {
        ZStack {
            Color.backgroundPrimary.edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                BottomNavBar(selectedTab: $selectedTab)
            }
        }
    }
}

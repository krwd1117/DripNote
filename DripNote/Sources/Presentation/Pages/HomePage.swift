import SwiftUI

struct HomePage: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundPrimary.edgesIgnoringSafeArea(.all) // Full screen background

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Search Bar (Molecule or Organism - TBD)
                        Text("Search Bar Placeholder")
                            .font(.appHeadline)
                            .foregroundColor(.textPrimary)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.backgroundSecondary)
                            .cornerRadius(12)
                        
                        // Categories (Organism)
                        Text("Categories Placeholder")
                            .font(.appHeadline)
                            .foregroundColor(.textPrimary)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.backgroundSecondary)
                            .cornerRadius(12)

                        // Recommended Recipes (Organism)
                        VStack(alignment: .leading) {
                            Text("추천 레시피")
                                .font(.appHeadline)
                                .foregroundColor(.textPrimary)
                                .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(0..<5) { _ in // Placeholder cards
                                        RecipeCard(
                                            title: "에티오피아 예가체프",
                                            baristaName: "김정완",
                                            coffeeBeans: "Ethiopia Yirgacheffe G1",
                                            imageUrl: "https://source.unsplash.com/random/400x300?coffee,beans"
                                        )
                                        .frame(width: 200)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        // Recent Brewing History (Organism)
                        VStack(alignment: .leading) {
                            Text("최근 추출 기록")
                                .font(.appHeadline)
                                .foregroundColor(.textPrimary)
                                .padding(.horizontal)
                            
                            ForEach(0..<3) { _ in // Placeholder history items
                                Text("Recent Item Placeholder")
                                    .font(.appBody)
                                    .foregroundColor(.textSecondary)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.backgroundSecondary)
                                    .cornerRadius(12)
                                    .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.vertical, 20)
                }
            }
            .navigationBarHidden(true) // Hide default navigation bar
        }
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}

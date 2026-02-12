import SwiftUI

struct RecipeCard: View {
    let title: String
    let baristaName: String
    let coffeeBeans: String
    let imageUrl: String? // For premium design with coffee photos

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let urlString = imageUrl, let url = URL(string: urlString) {
                // AsyncImage for loading coffee photos
                AsyncImage(url: url) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 150)
                        .clipped()
                } placeholder: {
                    Color.backgroundSecondary // Placeholder color
                }
                .cornerRadius(8)
            }
            
            Text(title)
                .font(.appHeadline)
                .foregroundColor(.textPrimary)
            
            Text(baristaName)
                .font(.appBody)
                .foregroundColor(.textSecondary)
            
            Text(coffeeBeans)
                .font(.appCaption)
                .foregroundColor(.textSecondary)
        }
        .roundedCard(
            backgroundColor: .backgroundSecondary,
            padding: EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        )
    }
}

struct RecipeCard_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.backgroundPrimary.edgesIgnoringSafeArea(.all)
            RecipeCard(
                title: "에티오피아 예가체프",
                baristaName: "김정완",
                coffeeBeans: "Ethiopia Yirgacheffe G1",
                imageUrl: "https://source.unsplash.com/random/400x300?coffee,beans"
            )
            .padding()
        }
    }
}

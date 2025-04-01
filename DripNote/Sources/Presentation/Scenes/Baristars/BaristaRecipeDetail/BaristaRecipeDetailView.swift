import SwiftUI
import DripNoteDomain

public struct BaristaRecipeDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: BaristaRecipeDetailViewModel
    
    public init(recipe: BaristaBrewingRecipe) {
        _viewModel = StateObject(wrappedValue: BaristaRecipeDetailViewModel(recipe: recipe))
    }
    
    public var body: some View {
        ScrollView {
            if let recipe = viewModel.recipe {
                VStack(spacing: 24) {
                    // 기본 정보 섹션
                    RecipeBasicInfoSection(
                        title: recipe.title,
                        baristaName: recipe.baristaName,
                        coffeeBeans: recipe.coffeeBeans,
                        brewingTemperature: recipe.brewingTemperature
                    )
                    
                    // 추출 설정 섹션
                    RecipeBrewingSettingsSection(
                        brewingMethod: recipe.brewingMethod,
                        brewingTemperature: recipe.brewingTemperature,
                        waterTemperature: recipe.waterTemperature,
                        grindSize: recipe.grindSize,
                        coffeeWeight: recipe.coffeeWeight,
                        waterWeight: recipe.waterWeight
                    )
                    
                    // 추출 단계 섹션
                    RecipeBrewingStepsSection(steps: recipe.steps)
                    
                    // 메모 섹션
                    if !recipe.notes.isEmpty {
                        RecipeNotesSection(notes: recipe.notes)
                    }
                    
                    // 유튜브 링크
                    if let youtubeURL = recipe.youtubeURL {
                        YoutubeSection(url: youtubeURL)
                    }
                    
                    // 매장 정보
                    if let storeInfo = recipe.storeInfo {
                        StoreInfoSection(info: storeInfo)
                    }
                }
                .padding(20)
            }
        }
        .background(NavigationGestureEnabler())
        .scrollContentBackground(.hidden)
        .background(Color.Custom.primaryBackground.color)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(Color.Custom.accentBrown.color)
                }
            }
        }
        .toolbarBackground(.hidden, for: .tabBar)
        .safeAreaInset(edge: .bottom) {
            Color.clear
                .frame(height: 50)
        }
    }
}

// MARK: - Youtube Section
private struct YoutubeSection: View {
    let url: URL
    
    var body: some View {
        Link(destination: url) {
            HStack {
                Image(systemName: "play.circle.fill")
                    .font(.system(size: 24))
                Text("유튜브에서 보기")
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(.red)
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(Color.Custom.secondaryBackground.color)
            .cornerRadius(12)
        }
    }
}

// MARK: - Store Info Section
private struct StoreInfoSection: View {
    let info: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("매장 정보")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color.Custom.darkBrown.color)
            
            Text(info)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.Custom.secondaryBackground.color)
        .cornerRadius(12)
    }
}

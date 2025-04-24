import SwiftUI
import SwiftData

import DripNoteDomain
import DripNoteThirdParty

public struct RecipeDetailView: View {
    @EnvironmentObject private var coordinator: RecipeCoordinator
    @EnvironmentObject private var tabBarState: TabBarState
    @StateObject private var viewModel: RecipeDetailViewModel
    
    public init(viewModel: RecipeDetailViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // 기본 정보 섹션
                RecipeBasicInfoSection(
                    title: viewModel.recipe.title,
                    baristaName: viewModel.recipe.baristaName,
                    coffeeBeans: viewModel.recipe.coffeeBeans,
                    brewingTemperature: viewModel.recipe.brewingTemperature
                )
                
                // 추출 설정 섹션
                RecipeBrewingSettingsSection(
                    brewingMethod: viewModel.recipe.brewingMethod,
                    brewingTemperature: viewModel.recipe.brewingTemperature,
                    waterTemperature: viewModel.recipe.waterTemperature,
                    grindSize: viewModel.recipe.grindSize,
                    coffeeWeight: viewModel.recipe.coffeeWeight,
                    waterWeight: viewModel.recipe.waterWeight
                )
                
                if !viewModel.recipe.steps.isEmpty {
                    // 추출 단계 섹션
                    RecipeBrewingStepsSection(steps: viewModel.recipe.steps)
                }
                
                // 메모 섹션
                if !viewModel.recipe.notes.isEmpty {
                    RecipeNotesSection(notes: viewModel.recipe.notes)
                }
            }
            .padding(20)
        }
        .enableNavigationGesture()
        .scrollContentBackground(.hidden)
        .background(Color.Custom.primaryBackground.color)
        .navigationTitle("\(viewModel.recipe.title)")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    coordinator.pop()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(Color.Custom.accentBrown.color)
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    coordinator.push(.recipeEdit(viewModel.recipe))
                }, label: {
                    Text("Common.Edit")
                        .foregroundColor(Color.Custom.accentBrown.color)
                })
            }
        }
        .toolbarBackground(.hidden, for: .tabBar)
        .safeAreaInset(edge: .bottom) {
            Color.clear
                .frame(height: 50)
        }
    }
}

import Foundation
import SwiftData
import DripNoteDomain

@MainActor
public final class RecipeFormViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var baristaName: String = ""
    @Published var coffeeBeans: String = ""
    @Published var selectedMethod: BrewingMethod = .v60
    @Published var brewingTemperature: BrewingTemperature = .hot
    @Published var grindSize: String = ""
    @Published var coffeeWeight: Double = 20
    @Published var waterWeight: Double = 200
    @Published var waterTemperature: Double = 93
    @Published var steps: [BrewingStep] = []
    @Published var notes: String = ""
    
    let recipe: BrewingRecipe?
    private let useCase: RecipeUseCase
    
    var isValidRecipe: Bool {
        !title.isEmpty
        && !coffeeWeight.isZero
        && !waterWeight.isZero
        && !waterTemperature.isZero
    }
    
    public init(recipe: BrewingRecipe? = nil, useCase: RecipeUseCase) {
        self.recipe = recipe
        self.useCase = useCase
        
        if let recipe = recipe {
            self.title = recipe.title
            self.baristaName = recipe.baristaName
            self.coffeeBeans = recipe.coffeeBeans
            self.selectedMethod = recipe.brewingMethod
            self.brewingTemperature = recipe.brewingTemperature
            self.grindSize = recipe.grindSize
            self.coffeeWeight = recipe.coffeeWeight
            self.waterWeight = recipe.waterWeight
            self.waterTemperature = recipe.waterTemperature
            self.steps = recipe.steps
            self.notes = recipe.notes
        }
    }
    
    func addStep(pourAmount: Double, pourTime: Double, desc: String) {
        let newStep = BrewingStep(
            pourNumber: steps.count + 1,
            pourAmount: pourAmount,
            pourTime: pourTime,
            desc: desc
        )
        steps.append(newStep)
    }
    
    func removeStep(at index: Int) {
        steps.remove(at: index)
        // 남은 단계들의 번호를 재정렬
        for i in index..<steps.count {
            steps[i].pourNumber = i + 1
        }
    }
    
    func updateStep(_ step: BrewingStep, pourAmount: Double, pourTime: Double, desc: String) {
        if let index = steps.firstIndex(where: { $0.pourNumber == step.pourNumber }) {
            steps[index].pourAmount = pourAmount
            steps[index].pourTime = pourTime
            steps[index].desc = desc
        }
    }
    
    @MainActor
    func saveRecipe(modelContext: ModelContext) async throws {
        if let existingRecipe = recipe {
            // 기존 레시피 업데이트
            existingRecipe.title = title
            existingRecipe.baristaName = baristaName
            existingRecipe.coffeeBeans = coffeeBeans
            existingRecipe.brewingMethod = selectedMethod
            existingRecipe.brewingTemperature = brewingTemperature
            existingRecipe.coffeeWeight = coffeeWeight
            existingRecipe.waterWeight = waterWeight
            existingRecipe.waterTemperature = waterTemperature
            existingRecipe.grindSize = grindSize
            existingRecipe.steps = steps
            existingRecipe.notes = notes
            
            try await useCase.updateRecipe(existingRecipe)
        } else {
            // 새 레시피 생성
            let newRecipe = BrewingRecipe(
                id: UUID(),
                title: title,
                baristaName: baristaName,
                coffeeBeans: coffeeBeans,
                brewingMethod: selectedMethod,
                brewingTemperature: brewingTemperature,
                coffeeWeight: coffeeWeight,
                waterWeight: waterWeight,
                waterTemperature: waterTemperature,
                grindSize: grindSize,
                steps: steps,
                notes: notes
            )
            
            try await useCase.createRecipe(newRecipe)
        }
    }
}

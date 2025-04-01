import Foundation
import DripNoteDomain

@MainActor
final class BaristasViewModel: ObservableObject {
    @Published var recipes: [BaristaBrewingRecipe] = []
    @Published var isLoading = true
    @Published private var error: Error?
    
    private let useCase: FirestoreRecipeUseCase
    
    init(useCase: FirestoreRecipeUseCase) {
        self.useCase = useCase
    }
    
    let baristaRecipes: [BaristaBrewingRecipe] = [
        BaristaBrewingRecipe(
            id: UUID().uuidString,
            title: "4:6 Method",
            baristaName: "Tetsu Kasuya",
            coffeeBeans: "Ethiopia Yirgacheffe",
            brewingMethod: .v60,
            brewingTemperature: .hot,
            coffeeWeight: 20,
            waterWeight: 300,
            waterTemperature: 92,
            grindSize: "Medium-Coarse",
            steps: [
                BaristaBrewingStep(pourNumber: 1, pourAmount: 120, pourTime: 0, desc: "단맛을 추출하기 위한 첫 번째 푸어링"),
                BaristaBrewingStep(pourNumber: 2, pourAmount: 90, pourTime: 60, desc: "신맛을 조절하는 두 번째 푸어링"),
                BaristaBrewingStep(pourNumber: 3, pourAmount: 90, pourTime: 120, desc: "쓴맛을 조절하는 마지막 푸어링")
            ],
            notes: "맛의 밸런스를 조절하는 데 탁월한 방식. 4:6 메서드는 초보자에게도 추천.",
            youtubeURL: URL(string: "https://www.youtube.com/watch?v=uLbdiG4iqlI"),
            storeInfo: "Philocoffea Roastery & Laboratory, Japan"
        ),
        BaristaBrewingRecipe(
            id: UUID().uuidString,
            title: "James Hoffmann Easy V60",
            baristaName: "James Hoffmann",
            coffeeBeans: "Kenya AA",
            brewingMethod: .v60,
            brewingTemperature: .hot,
            coffeeWeight: 15,
            waterWeight: 250,
            waterTemperature: 94,
            grindSize: "Medium",
            steps: [
                BaristaBrewingStep(pourNumber: 1, pourAmount: 40, pourTime: 0, desc: "프리인퓨전 (30초간 뜸들이기)"),
                BaristaBrewingStep(pourNumber: 2, pourAmount: 210, pourTime: 30, desc: "잔여 물을 한 번에 붓기")
            ],
            notes: "간결하고 재현성 좋은 추출 방식. 누구나 맛있게 내릴 수 있다.",
            youtubeURL: URL(string: "https://www.youtube.com/watch?v=29dYA7tTZfI"),
            storeInfo: "Square Mile Coffee Roasters, London"
        ),
        BaristaBrewingRecipe(
            id: UUID().uuidString,
            title: "Kurasu Kyoto Clean Cup",
            baristaName: "Kurasu Barista Team",
            coffeeBeans: "Guatemala Huehuetenango",
            brewingMethod: .v60,
            brewingTemperature: .hot,
            coffeeWeight: 16,
            waterWeight: 240,
            waterTemperature: 92,
            grindSize: "Medium-Coarse",
            steps: [
                BaristaBrewingStep(pourNumber: 1, pourAmount: 30, pourTime: 0, desc: "0:00 - 프리인퓨전"),
                BaristaBrewingStep(pourNumber: 2, pourAmount: 90, pourTime: 30, desc: "0:30 - 두 번째 푸어링"),
                BaristaBrewingStep(pourNumber: 3, pourAmount: 60, pourTime: 60, desc: "1:00 - 세 번째 푸어링"),
                BaristaBrewingStep(pourNumber: 4, pourAmount: 60, pourTime: 90, desc: "1:30 - 네 번째 푸어링")
            ],
            notes: "일본 스타일의 섬세한 추출, 클린컵과 밸런스가 좋음.",
            youtubeURL: URL(string: "https://www.youtube.com/watch?v=GkFZPwFSrd8"),
            storeInfo: "Kurasu Kyoto, Japan"
        )
    ]
    
    func fetchRecipes() async {
        isLoading = true
        
        do {
            recipes = try await useCase.fetchRecipes()
        } catch {
            print("Error: \(error)")
        }
        
        isLoading = false
    }
    
    func test() {
        baristaRecipes.forEach { recipe in
            Task {
                try await useCase.createRecipe(recipe)
            }
        }
    }
}

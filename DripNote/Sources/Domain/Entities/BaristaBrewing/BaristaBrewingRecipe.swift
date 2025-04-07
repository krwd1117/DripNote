import Foundation

public final class BaristaBrewingRecipe: Identifiable, Codable {
    
    public var id: String
    public var title: String
    public var baristaName: String
    public var coffeeBeans: String
    public var coffeeBeansStoreURL: LocalizedURL?
    public var brewingMethod: BrewingMethod
    public var brewingMethodStoreURL: LocalizedURL?
    public var brewingTemperature: BrewingTemperature
    public var coffeeWeight: Double
    public var waterWeight: Double
    public var waterTemperature: Double
    public var grindSize: String
    public var steps: [BaristaBrewingStep]
    public var notes: String
    public var youtubeURL: URL?
    public var storeInfo: String?
    
    public init(
        id: String,
        title: String,
        baristaName: String,
        coffeeBeans: String,
        coffeeBeansStoreURL: LocalizedURL? = nil,
        brewingMethod: BrewingMethod,
        brewingMethodStoreURL: LocalizedURL? = nil,
        brewingTemperature: BrewingTemperature,
        coffeeWeight: Double,
        waterWeight: Double,
        waterTemperature: Double,
        grindSize: String,
        steps: [BaristaBrewingStep] = [],
        notes: String,
        youtubeURL: URL? = nil,
        storeInfo: String? = nil
    ) {
        self.id = id
        self.title = title
        self.baristaName = baristaName
        self.coffeeBeans = coffeeBeans
        self.coffeeBeansStoreURL = coffeeBeansStoreURL
        self.brewingMethod = brewingMethod
        self.brewingMethodStoreURL = brewingMethodStoreURL
        self.brewingTemperature = brewingTemperature
        self.coffeeWeight = coffeeWeight
        self.waterWeight = waterWeight
        self.waterTemperature = waterTemperature
        self.grindSize = grindSize
        self.steps = steps
        self.notes = notes
        self.youtubeURL = youtubeURL
        self.storeInfo = storeInfo
    }
    
    public func toEntity(with steps: [BaristaBrewingStep]) -> BrewingRecipe {
        var brewingSteps: [BrewingStep] {
            return steps.compactMap {
                $0.toEntity()
            }
        }
        return BrewingRecipe(
            id: UUID(uuidString: self.id),
            title: self.title,
            baristaName: self.baristaName,
            coffeeBeans: self.coffeeBeans,
            coffeeBeansStoreURL: self.coffeeBeansStoreURL,
            brewingMethod: self.brewingMethod,
            brewingMethodStoreURL: self.brewingMethodStoreURL,
            brewingTemperature: self.brewingTemperature,
            coffeeWeight: self.coffeeWeight,
            waterWeight: self.waterWeight,
            waterTemperature: self.waterTemperature,
            grindSize: self.grindSize,
            steps: brewingSteps,
            notes: self.notes
        )
    }
}

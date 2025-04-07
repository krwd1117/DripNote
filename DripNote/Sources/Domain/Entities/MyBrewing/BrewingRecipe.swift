import Foundation
import SwiftData

@Model
public final class BrewingRecipe: Identifiable {
    @Attribute(.unique) public var id: UUID
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
    @Relationship(deleteRule: .cascade) public var steps: [BrewingStep]
    public var notes: String
    
    public init(
        id: UUID?,
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
        steps: [BrewingStep] = [],
        notes: String
    ) {
        self.id = id ?? UUID()
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
    }
    
    public var totalBrewTime: Double {
        guard let lastStep = steps.max(by: { $0.pourTime < $1.pourTime }) else { return 0 }
        return lastStep.pourTime
    }
}

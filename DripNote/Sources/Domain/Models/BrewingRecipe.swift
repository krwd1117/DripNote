import Foundation
import SwiftData

@Model
public final class BrewingRecipe: Identifiable {
    public var id: String = UUID().uuidString
    public var title: String
    public var baristaName: String
    public var coffeeBeans: String
    public var brewingMethod: BrewingMethod
    public var coffeeWeight: Double
    public var waterWeight: Double
    public var waterTemperature: Double
    public var grindSize: String
    @Relationship(deleteRule: .cascade) public var steps: [BrewingStep]
    public var notes: String
    
    public init(
        title: String,
        baristaName: String,
        coffeeBeans: String,
        brewingMethod: BrewingMethod,
        coffeeWeight: Double,
        waterWeight: Double,
        waterTemperature: Double,
        grindSize: String,
        steps: [BrewingStep] = [],
        notes: String
    ) {
        self.title = title
        self.baristaName = baristaName
        self.coffeeBeans = coffeeBeans
        self.brewingMethod = brewingMethod
        self.coffeeWeight = coffeeWeight
        self.waterWeight = waterWeight
        self.waterTemperature = waterTemperature
        self.grindSize = grindSize
        self.steps = steps
        self.notes = notes
    }
    
    // MARK: - Computed Properties
    public var totalBrewTime: Double {
        guard let lastStep = steps.max(by: { $0.pourTime < $1.pourTime }) else { return 0 }
        return lastStep.pourTime + 30 // 마지막 푸어 후 30초 드립
    }
    
    public var totalWaterAmount: Double {
        steps.reduce(0) { $0 + $1.pourAmount }
    }
} 

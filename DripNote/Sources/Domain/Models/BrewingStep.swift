import Foundation
import SwiftData

@Model
public final class BrewingStep {
    public var pourNumber: Int
    public var pourAmount: Double
    public var pourTime: Double
    public var desc: String
    
    public init(
        pourNumber: Int,
        pourAmount: Double,
        pourTime: Double,
        desc: String
    ) {
        self.pourNumber = pourNumber
        self.pourAmount = pourAmount
        self.pourTime = pourTime
        self.desc = desc
    }
    
    public var formattedTime: String {
        let totalSeconds = Int(pourTime)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return minutes > 0 ? "\(minutes)분 \(seconds)초" : "\(seconds)초"
    }
}

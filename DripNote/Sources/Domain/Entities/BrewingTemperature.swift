import Foundation

public enum BrewingTemperature: String, Codable, CaseIterable, Hashable {
    case hot
    case ice
    
    public var displayName: String {
        switch self {
        case .hot: return "HOT"
        case .ice: return "ICE"
        }
    }
}

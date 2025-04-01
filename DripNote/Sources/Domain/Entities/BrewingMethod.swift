import Foundation

public enum BrewingMethod: String, Codable, CaseIterable {
    case v60 = "v60"
    case kalita = "kalita"
    case chemex = "chemex"
    case aeropress = "aeropress"
    case frenchPress = "frenchPress"
    case siphon = "siphon"
    case other = "other"
    
    public var displayName: String {
        return self.rawValue
    }
} 

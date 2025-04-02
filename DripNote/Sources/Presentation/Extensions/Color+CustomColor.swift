import SwiftUI

extension Color {
    public enum Custom {
        case accentBrown
        case calmSky
        case darkBrown
        case lightBrown
        case primaryBackground
        case secondaryBackground
        case warmTerracotta
        
        public var color: Color {
            switch self {
            case .accentBrown:
                Color("accentBrown")
            case .calmSky:
                Color("calmSky")
            case .darkBrown:
                Color("darkBrown")
            case .lightBrown:
                Color("lightBrown")
            case .primaryBackground:
                Color("primaryBackground")
            case .secondaryBackground:
                Color("secondaryBackground")
            case .warmTerracotta:
                Color("warmTerracotta")
            }
        }
    }
}

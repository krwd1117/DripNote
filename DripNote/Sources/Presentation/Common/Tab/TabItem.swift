import SwiftUI

public enum TabItem: Int, CaseIterable {
    case myRecipes
    case baristas
    case settings
    
    var title: String {
        switch self {
        case .myRecipes:
            return String(localized: "Tab.Home")
        case .baristas:
            return String(localized: "Tab.Barista")
        case .settings:
            return String(localized: "Tab.Settings")
        }
    }
    
    var icon: String {
        switch self {
        case .myRecipes:
            return "mug"
        case .baristas:
            return "person.2"
        case .settings:
            return "gearshape"
        }
    }
    
    var selectedIcon: String {
        switch self {
        case .myRecipes:
            return "mug.fill"
        case .baristas:
            return "person.2.fill"
        case .settings:
            return "gearshape.fill"
        }
    }
    
    var showsFloatingButton: Bool {
        switch self {
        case .myRecipes:
            return true
        default:
            return false
        }
    }
}

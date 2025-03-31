import SwiftUI

public enum TabItem: Int, CaseIterable {
    case myRecipes
    case baristas
    case settings
    
    var title: String {
        switch self {
        case .myRecipes:
            return "내 레시피"
        case .baristas:
            return "바리스타"
        case .settings:
            return "설정"
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

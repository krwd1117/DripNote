import SwiftUI

struct TabItem: Identifiable, Equatable, CaseIterable { // Make Identifiable for ForEach
    let id = UUID() // Use UUID for unique identification
    let title: String
    let iconName: String
    
    // Define your tabs here
    static let home = TabItem(title: "홈", iconName: "house")
    static let beans = TabItem(title: "원두", iconName: "leaf")
    static let stats = TabItem(title: "통계", iconName: "chart.bar")
    static let settings = TabItem(title: "설정", iconName: "gearshape")
    
    // All cases for ForEach
    static var allCases: [TabItem] = [.home, .beans, .stats, .settings]
}

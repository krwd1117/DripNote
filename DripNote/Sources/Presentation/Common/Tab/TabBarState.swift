import SwiftUI

public final class TabBarState: ObservableObject {
    @Published var isVisible: Bool = true
    
    public init(isVisible: Bool = true) {
        withAnimation {
            self.isVisible = isVisible
        }
    }
} 

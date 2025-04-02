import SwiftUI
import DripNoteCore

public final class SettingsCoordinator: Coordinator {
    public enum Route: Hashable {
        case profile
        case about
    }
    
    @Published public var navigationPath = NavigationPath()
    
    public init() {}
    
    public func push(_ route: Route) {
        navigationPath.append(route)
    }
    
    @ViewBuilder
    public func view(for route: Route) -> some View {
        switch route {
        case .profile:
            Text("Profile")
        case .about:
            Text("About")
        }
    }
} 
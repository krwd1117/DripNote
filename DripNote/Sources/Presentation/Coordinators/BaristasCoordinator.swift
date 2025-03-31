import SwiftUI
import DripNoteCore

public final class BaristasCoordinator: Coordinator {
    public enum Route: Hashable {
        case noteDetail(String)
        case createNote
    }
    
    @Published public var navigationPath = NavigationPath()
    
    public init() {}
    
    public func push(_ route: Route) {
        navigationPath.append(route)
    }
    
    @ViewBuilder
    public func view(for route: Route) -> some View {
        switch route {
        case .noteDetail(let id):
            Text("Note Detail: \(id)")
        case .createNote:
            Text("Create Note")
        }
    }
} 

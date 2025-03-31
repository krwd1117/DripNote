import SwiftUI

public protocol Coordinator: ObservableObject {
    associatedtype Route: Hashable
    
    var navigationPath: NavigationPath { get set }
    
    func push(_ route: Route)
    func pop()
    func popToRoot()
}

public extension Coordinator {
    func pop() {
        guard !navigationPath.isEmpty else { return }
        navigationPath.removeLast()
    }
    
    func popToRoot() {
        guard !navigationPath.isEmpty else { return }
        navigationPath = NavigationPath()
    }
} 
import SwiftUI

public struct SettingsView: View {
    @StateObject private var coordinator = SettingsCoordinator()
    
    public init() {}
    
    public var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            List {
                Button("프로필") {
                    coordinator.push(.profile)
                }
                
                Button("앱 정보") {
                    coordinator.push(.about)
                }
            }
            .navigationTitle("설정")
            .navigationDestination(for: SettingsCoordinator.Route.self) { route in
                coordinator.view(for: route)
            }
        }
    }
} 
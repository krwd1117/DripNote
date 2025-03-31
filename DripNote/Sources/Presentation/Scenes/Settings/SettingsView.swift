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
                .foregroundColor(Color.Custom.darkBrown.color)
                
                Button("앱 정보") {
                    coordinator.push(.about)
                }
                .foregroundColor(Color.Custom.darkBrown.color)
            }
            .scrollContentBackground(.hidden)
            .background(Color.Custom.primaryBackground.color)
            .navigationTitle("설정")
            .tint(Color.Custom.darkBrown.color)
            .navigationDestination(for: SettingsCoordinator.Route.self) { route in
                coordinator.view(for: route)
            }
        }
    }
} 

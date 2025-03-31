import SwiftUI

public struct BaristasView: View {
    @StateObject private var coordinator = BaristasCoordinator()
    
    public init() {}
    
    public var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            List {
                Button("노트 생성") {
                    coordinator.push(.createNote)
                }
                .foregroundColor(Color.Custom.darkBrown.color)
                
                Button("노트 상세") {
                    coordinator.push(.noteDetail("1"))
                }
                .foregroundColor(Color.Custom.darkBrown.color)
            }
            .scrollContentBackground(.hidden)
            .background(Color.Custom.primaryBackground.color)
            .navigationTitle("DripNote")
            .tint(Color.Custom.darkBrown.color)
            .navigationDestination(for: BaristasCoordinator.Route.self) { route in
                coordinator.view(for: route)
            }
        }
    }
} 

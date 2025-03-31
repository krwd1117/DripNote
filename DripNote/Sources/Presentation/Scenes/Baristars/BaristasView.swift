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
                
                Button("노트 상세") {
                    coordinator.push(.noteDetail("1"))
                }
            }
            .navigationTitle("DripNote")
            .navigationDestination(for: BaristasCoordinator.Route.self) { route in
                coordinator.view(for: route)
            }
        }
    }
} 

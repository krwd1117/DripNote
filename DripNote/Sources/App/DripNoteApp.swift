import DripNoteCore
import DripNoteData
import DripNoteDomain
import DripNoteDI
import DripNotePresentation

import SwiftData
import SwiftUI

@main
struct DripNoteApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @State private var showingSplash = true
    @StateObject private var splashViewModel: SplashViewModel = SplashViewModel()
    
    let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainerFactory.create()
        } catch {
            fatalError("Could not initialize ModelContainer: \(error)")
        }
        
        setupDependencies()
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if showingSplash {
                    SplashView(viewModel: splashViewModel)
                        .transition(.opacity)
                } else {
                    MainContainer()
                }
            }
            .onReceive(splashViewModel.$isFinished) { _ in
                withAnimation {
                    showingSplash = false
                }
            }
        }
        .modelContainer(container)
    }
    
    private func setupDependencies() {
        DIContainer.shared.build(modelContext: container.mainContext)
    }
}

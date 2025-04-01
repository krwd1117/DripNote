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
        .modelContainer(appDelegate.container)
    }
}

//import SwiftUI
import Combine
import DripNoteCore

public final class SplashViewModel: ObservableObject {
    @Published public var isFinished: Bool = false

    public init() {
        setupAnimation()
    }
    
    private func setupAnimation() {
        Task {
            await MainActor.run {
                self.isFinished = true
            }
        }
    }
} 

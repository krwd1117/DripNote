//import SwiftUI
import Combine
import DripNoteCore

public final class SplashViewModel: ObservableObject {
    @Published public var isFinished: Bool = false

    public init() {
        setupAnimation()
    }
    
    private func setupAnimation() {
        // TODO: 사전 작업
        Task {
            await MainActor.run {
                self.isFinished = true
            }
        }
    }
} 

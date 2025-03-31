//import SwiftUI
import Combine
import DripNoteCore

public final class SplashViewModel: ObservableObject {
    @Published public var isFinished: Bool = false

    public init() {
        setupAnimation()
    }
    
    private func setupAnimation() {
        // 스플래시 화면 애니메이션 시작
        Task {
            await MainActor.run {
                self.isFinished = true
            }
        }
    }
} 

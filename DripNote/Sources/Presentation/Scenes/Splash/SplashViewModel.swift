import Combine
import DripNoteCore

import AppTrackingTransparency
import AdSupport
import GoogleMobileAds

public final class SplashViewModel: ObservableObject {
    @Published public var isFinished: Bool = false
    
    public init() {}
    
    func setup() {
        Task { @MainActor in
            await requestTrackingAuthorizationIfNeeded()
            await initializeAdMob()
            self.isFinished = true
        }
    }
    
    @MainActor
    private func requestTrackingAuthorizationIfNeeded() async {
        if #available(iOS 14, *) {
            let status = await withCheckedContinuation { continuation in
                ATTrackingManager.requestTrackingAuthorization { status in
                    continuation.resume(returning: status)
                }
            }
            print("🛡️ Tracking status: \(status.rawValue)")
        }
    }
    
    @MainActor
    private func initializeAdMob() async {
        let status = await withCheckedContinuation { continuation in
            MobileAds.shared.start() { status in
                continuation.resume(returning: status)
            }
        }
        
        print("📡 AdMob initialized. Ready adapters: \(status)")
    }
}

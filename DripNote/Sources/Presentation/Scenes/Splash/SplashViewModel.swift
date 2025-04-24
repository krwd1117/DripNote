import Combine
import DripNoteCore

import AppTrackingTransparency
import AdSupport

import DripNoteThirdParty

public final class SplashViewModel: ObservableObject {
    @Published public var isFinished: Bool = false
    
    public init() {}
    
    func setup() {
        Task { @MainActor in
            
            // TestFilght를 통해 설치한 경우 권한 요청을 무시하고 넘어가는 경우가 발생하여 이를 해결하기 위해 추가
            try await Task.sleep(for: .seconds(0.5))
            
            await requestTrackingAuthorizationIfNeeded()
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
}

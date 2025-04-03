import GoogleMobileAds

// MARK: - 모바일 광고 초기화
// https://developers.google.com/admob/ios/quick-start?hl=ko#swiftui
@MainActor
public func initializeAdMob() async {
    let status = await withCheckedContinuation { continuation in
        MobileAds.shared.start() { status in
            continuation.resume(returning: status)
        }
    }
    
    print("📡 AdMob initialized. Ready adapters: \(status)")
}

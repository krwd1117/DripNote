import SwiftUI
import SwiftData

import DripNoteDI
import DripNoteData

import AppTrackingTransparency
import AdSupport
import FirebaseCore
import GoogleMobileAds

class AppDelegate: NSObject, UIApplicationDelegate {
    var container: ModelContainer!
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        
        Task {
            await requestTrackingAuthorizationIfNeeded()
        }
        
        do {
            container = try ModelContainerFactory.create()
            DIContainer.shared.build(modelContext: container.mainContext)
        } catch {
            fatalError("Could not initialize ModelContainer: \(error)")
        }
        
        return true
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

        initializeAdMob()
    }
        
    @MainActor
    private func initializeAdMob() {
        MobileAds.shared.start { status in
            let adapters = status.adapterStatusesByClassName
                .filter { $0.value.state == .ready }
                .map { $0.key }
                .joined(separator: ", ")

            print("📡 AdMob initialized. Ready adapters: \(adapters)")
        }
    }
}

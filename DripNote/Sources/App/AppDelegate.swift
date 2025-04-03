import SwiftUI
import SwiftData

import DripNoteDI
import DripNoteData
import DripNoteThirdParty

import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
    var container: ModelContainer!
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
    
        FirebaseApp.configure()
        
        initializeFirebaseRemoteConfig()
    
        do {
            container = try ModelContainerFactory.create()
            DIContainer.shared.build(modelContext: container.mainContext)
        } catch {
            fatalError("Could not initialize ModelContainer: \(error)")
        }
        
        return true
    }
}

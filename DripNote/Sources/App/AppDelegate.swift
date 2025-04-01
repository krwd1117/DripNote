import SwiftUI
import SwiftData

import FirebaseCore

import DripNoteDI
import DripNoteData

class AppDelegate: NSObject, UIApplicationDelegate {
    var container: ModelContainer!
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
//        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        do {
            container = try ModelContainerFactory.create()
            DIContainer.shared.build(modelContext: container.mainContext)
        } catch {
            fatalError("Could not initialize ModelContainer: \(error)")
        }
        
        return true
    }
}

import SwiftUI
import SwiftData

import DripNoteDI
import DripNoteData
import DripNoteThirdParty

import FirebaseCore
import Supabase

class AppDelegate: NSObject, UIApplicationDelegate {
    var container: ModelContainer!
    var supabaseClient: SupabaseClient!
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()

        supabaseClient = SupabaseClient(supabaseURL: URL(string: SupabaseConfig.url)!, supabaseKey: SupabaseConfig.anonKey)
        DIContainer.shared.register(SupabaseClient.self, instance: supabaseClient)
        
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self  // delegate 지정
    
        do {
            container = try ModelContainerFactory.create()
            DIContainer.shared.build(modelContext: container.mainContext)
        } catch {
            fatalError("Could not initialize ModelContainer: \(error)")
        }
        
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // 포그라운드에서 알림을 표시하기 위한 delegate 메서드
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .banner, .badge])
    }
}

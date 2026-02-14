import Foundation

enum SupabaseConfig {
    static let url: String = ProcessInfo.processInfo.environment["SUPABASE_URL"] ?? ""
    static let anonKey: String = ProcessInfo.processInfo.environment["SUPABASE_ANON_KEY"] ?? ""
}

import Foundation
import Supabase
import DripNoteDomain

final class SupabaseAuthDataSource {
    private let client: SupabaseClient

    init(client: SupabaseClient) {
        self.client = client
    }

    func currentUser() -> AuthUser? {
        guard let user = client.auth.session?.user else { return nil }
        return AuthUser(id: user.id.uuidString, email: user.email)
    }

    func signIn(email: String, password: String) async throws -> AuthUser {
        let session = try await client.auth.signIn(email: email, password: password)
        let user = session.user
        return AuthUser(id: user.id.uuidString, email: user.email)
    }

    func signUp(email: String, password: String) async throws -> AuthUser {
        let session = try await client.auth.signUp(email: email, password: password)
        let user = session.user
        return AuthUser(id: user.id.uuidString, email: user.email)
    }

    func signOut() async throws {
        try await client.auth.signOut()
    }
}

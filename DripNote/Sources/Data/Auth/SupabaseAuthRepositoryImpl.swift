import Foundation
import Supabase
import DripNoteDomain

public final class SupabaseAuthRepositoryImpl: AuthenticationRepository {
    private let dataSource: SupabaseAuthDataSource

    public init(client: SupabaseClient) {
        self.dataSource = SupabaseAuthDataSource(client: client)
    }

    public func currentUser() -> AuthUser? {
        dataSource.currentUser()
    }

    public func signIn(email: String, password: String) async throws -> AuthUser {
        try await dataSource.signIn(email: email, password: password)
    }

    public func signUp(email: String, password: String) async throws -> AuthUser {
        try await dataSource.signUp(email: email, password: password)
    }

    public func signOut() async throws {
        try await dataSource.signOut()
    }
}

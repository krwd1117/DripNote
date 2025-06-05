import Foundation

@MainActor
public protocol AuthenticationRepository {
    func currentUser() -> AuthUser?
    func signIn(email: String, password: String) async throws -> AuthUser
    func signUp(email: String, password: String) async throws -> AuthUser
    func signOut() async throws
}

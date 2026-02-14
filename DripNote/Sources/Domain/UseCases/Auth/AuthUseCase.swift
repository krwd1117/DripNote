import Foundation

@MainActor
public protocol AuthUseCase {
    func currentUser() -> AuthUser?
    func signIn(email: String, password: String) async throws -> AuthUser
    func signUp(email: String, password: String) async throws -> AuthUser
    func signOut() async throws
}

@MainActor
public final class DefaultAuthUseCase: AuthUseCase {
    private let repository: AuthenticationRepository

    public init(repository: AuthenticationRepository) {
        self.repository = repository
    }

    public func currentUser() -> AuthUser? {
        repository.currentUser()
    }

    public func signIn(email: String, password: String) async throws -> AuthUser {
        try await repository.signIn(email: email, password: password)
    }

    public func signUp(email: String, password: String) async throws -> AuthUser {
        try await repository.signUp(email: email, password: password)
    }

    public func signOut() async throws {
        try await repository.signOut()
    }
}

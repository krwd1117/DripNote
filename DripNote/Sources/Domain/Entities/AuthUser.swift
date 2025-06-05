import Foundation

public struct AuthUser: Identifiable {
    public let id: String
    public let email: String?

    public init(id: String, email: String?) {
        self.id = id
        self.email = email
    }
}

import Fluent
import Vapor
import JWT
import Foundation

final class User: Model, Content {

    struct Public: Content {
        let id: UUID
        let username: String
        let name: String
        let acronyms: [Acronym]
    }

    static let schema = "users"

    @ID
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Field(key: "username")
    var username: String

    @Field(key: "password_hash")
    var passwordHash: String

    @Children(for: \.$user)
    var acronyms: [Acronym]

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?


    init() {
    }

    init(id: UUID? = nil, name: String, username: String, passwordHash: String) {
        self.name = name
        self.username = username
        self.passwordHash = passwordHash
    }

    func asPublic() throws -> Public {
        Public(
                id: try requireID(),
                username: username,
                name: name,
                acronyms: acronyms
        )
    }
}

extension User: ModelAuthenticatable {
    static var usernameKey: KeyPath<User, Field<String>> = \User.$username

    static var passwordHashKey: KeyPath<User, Field<String>> = \User.$passwordHash

    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.passwordHash)
    }
}

struct JWTAuthenticatorBearer: JWTAuthenticator {
    typealias Payload = MyJwtPayload

    func authenticate(jwt: Payload, for request: Request) -> EventLoopFuture<Void> {
        do {
            try jwt.verify(using: request.application.jwt.signers.get()!)
            return User.find(jwt.id, on: request.db)
                    .unwrap(or: Abort(.notFound))
                    .map { user in
                        request.auth.login(user)
                    }
        } catch {
            return request.eventLoop.makeSucceededFuture(())
        }
    }
}

extension User {
    func generateToken(_ app: Application) throws -> String {
        let oneDayInSeconds: Double = 86400
        var expDate = Date()
        expDate.addTimeInterval(oneDayInSeconds * 7)

        let exp = ExpirationClaim(value: expDate)
        return try app.jwt.signers.get(kid: .private)!.sign(MyJwtPayload(id: self.id, username: self.username, exp: exp))

    }
}

extension User {
    struct Create: Content {
        var name: String
        var username: String
        var password: String
        var confirmPassword: String
    }


}

extension User.Create: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self, is: !.empty)
        validations.add("username", as: String.self, is: .count(3...) && .alphanumeric)
        validations.add("password", as: String.self, is: .count(8...))
    }
}
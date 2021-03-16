import Vapor
import Foundation
import FluentPostgresDriver


struct NewSession: Content {
    let token: String
    let user: User.Public
}

struct UsersController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let usersRoute = routes.grouped("api", "users")
        usersRoute.post(use: createHandler)
        usersRoute.get(use: getAllHandler)
        usersRoute.get(":userID", use: getHandler)
        usersRoute.get(":userID", "acronyms", use: getAcronymsHandler)
        usersRoute.group("login") { usr in
            usr.post(use: login)
        }
        usersRoute.grouped(JWTAuthenticatorBearer())
                .group("me") { user in
                    user.get(use: me)
                }
    }

    func createHandler(_ req: Request) throws -> EventLoopFuture<NewSession> {
        try User.Create.validate(content: req)
        let create = try req.content.decode(User.Create.self)
        guard create.password == create.confirmPassword else {
            throw Abort(.badRequest, reason: "Passwords did not match")
        }
        let user = try User(
                name: create.name,
                username: create.username,
                passwordHash: Bcrypt.hash(create.password)
        )
        var token: String!
        return checkIfUserExists(create.username, req: req).flatMap { exists in
            guard !exists else {
                return req.eventLoop.future(error: UserError.usernameTaken)
            }
            return user.save(on: req.db)
        }.flatMap { user.$acronyms.load(on: req.db) }
         .flatMapThrowing {
            // 1
            guard let newToken = try? user.generateToken(req.application) else {
                throw Abort(.internalServerError)
            }
            // 2
            token = newToken
            return NewSession(token: token, user: try user.asPublic())
        }
    }

    private func checkIfUserExists(_ username: String, req: Request) -> EventLoopFuture<Bool> {
        User.query(on: req.db)
                .filter(\.$username == username)
                .first()
                .map { $0 != nil }
    }

    func getAllHandler(_ req: Request) throws -> EventLoopFuture<[User.Public]> {
        User.query(on: req.db).with(\.$acronyms).all().flatMapThrowing { users -> [User.Public] in
            var usersAsPublic: [User.Public] = []
            for user in users {
                usersAsPublic.append(try user.asPublic())
            }
            return usersAsPublic
        }
    }

    func getHandler(_ req: Request) throws -> EventLoopFuture<User> {
        User.find(req.parameters.get("userID"), on: req.db)
                .unwrap(or: Abort(.notFound))
    }

    func getAcronymsHandler(_ req: Request) throws -> EventLoopFuture<[Acronym]> {
        User.find(req.parameters.get("userID"), on: req.db)
                .unwrap(or: Abort(.notFound))
                .flatMap { user in
                    user.$acronyms.get(on: req.db)
                }
    }

    func login(_ req: Request) throws -> EventLoopFuture<NewSession> {
        let userToLogin = try req.content.decode(UserLogin.self)
        var token: String!
        return User.query(on: req.db)
                .filter(\.$username == userToLogin.username)
                .with(\.$acronyms)
                .first()
                .unwrap(or: Abort(.notFound))
                .flatMapThrowing { dbUser -> User in
                    let verify = try dbUser.verify(password: userToLogin.password)
                    if verify == false {
                        throw Abort(.unauthorized)
                    }
                    let _ = req.auth.login(dbUser)
                    let user = try req.auth.require(User.self)
                    token = try user.generateToken(req.application)
                    return user
                }.flatMapThrowing { user in
                    NewSession(token: token, user: try user.asPublic())
                }
    }
    func me(_ req: Request) throws -> EventLoopFuture<Me> {
        let user = try req.auth.require(User.self)
        let username = user.username
        return User.query(on: req.db)
                .filter(\.$username == username)
                .first()
                .unwrap(or: Abort(.notFound))
                .map { usr in
                    Me(id: UUID(), username: username)
                }
    }
}

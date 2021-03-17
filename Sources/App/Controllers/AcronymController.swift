import Vapor
import Fluent

struct CreateAcronymData: Content {
    let short: String
    let long: String
}


struct AcronymsController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let acronymsRoutes = routes.grouped("api", "acronyms").grouped(JWTAuthenticatorBearer())
        acronymsRoutes.get(use: getAllHandler)
        acronymsRoutes.post(use: createHandler)
        acronymsRoutes.get(":acronymID", use: getHandler)
        acronymsRoutes.put(":acronymID", use: updateHandler)
        acronymsRoutes.delete(":acronymID", use: deleteHandler)
        acronymsRoutes.get("search", use: searchHandler)
        acronymsRoutes.get("first", use: getFirstHandler)
        acronymsRoutes.get("sorted", use: sortedHandler)
        acronymsRoutes.get(":acronymID", "user", use: getUserHandler)
        acronymsRoutes.post(":acronymID", "categories", ":categoryID", use: addCategoriesHandler)
        acronymsRoutes.post(":acronymID", "categories", use: getCategoriesHandler)
        acronymsRoutes.delete(":acronymID", "categories", ":categoryID", use: removeCategoriesHandler)
    }

    func getAllHandler(_ req: Request) throws -> EventLoopFuture<[Acronym.Public]> {
        let user = try req.auth.require(User.self)
        return Acronym.query(on: req.db)
                .filter(\.$user.$id == user.id!)
                .all()
                .flatMapThrowing { acronyms in
                    var acronymsAsPublic: [Acronym.Public] = []
                    for acronym in acronyms {
                        acronymsAsPublic.append(try acronym.asPublic())
                    }
                    return acronymsAsPublic
                }
    }

    func createHandler(_ req: Request) throws -> EventLoopFuture<Acronym.Public> {
        let data = try req.content.decode(CreateAcronymData.self)
        let user = try req.auth.require(User.self)
        let acronym = try Acronym(short: data.short, long: data.long, userID: user.requireID())
        return acronym.save(on: req.db).flatMapThrowing { try acronym.asPublic() }
    }

    func getHandler(_ req: Request) throws -> EventLoopFuture<Acronym.Public> {
        guard let acronymID: UUID = req.parameters.get("acronymID", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        let user = try req.auth.require(User.self)
        return Acronym.query(on: req.db)
                .filter(\.$id == acronymID)
                .filter(\.$user.$id == user.id!)
                .first()
                .unwrap(or: Abort(.notFound))
                .flatMapThrowing { acronym in try acronym.asPublic() }
    }

    func updateHandler(_ req: Request) throws -> EventLoopFuture<Acronym.Public> {
        guard let acronymID: UUID = req.parameters.get("acronymID", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        let updateData = try req.content.decode(CreateAcronymData.self)
        let user = try req.auth.require(User.self)
        return Acronym.query(on: req.db)
                .filter(\.$id == acronymID)
                .filter(\.$user.$id == user.id!)
                .first()
                .unwrap(or: Abort(.unauthorized))
                .flatMap { acronym in
                    acronym.short = updateData.short
                    acronym.long = updateData.long
                    return acronym.save(on: req.db).flatMapThrowing {
                        try acronym.asPublic()
                    }
                }
    }

    func deleteHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let acronymID: UUID = req.parameters.get("acronymID", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        let user = try req.auth.require(User.self)
        return Acronym.query(on: req.db)
                .filter(\.$id == acronymID)
                .filter(\.$user.$id == user.id!)
                .first()
                .unwrap(or: Abort(.notFound))
                .flatMap { acronym in
                    acronym.delete(on: req.db)
                            .transform(to: .noContent)
                }
    }

    func searchHandler(_ req: Request) throws -> EventLoopFuture<[Acronym.Public]> {
        guard let searchTerm = req.query[String.self, at: "term"] else {
            throw Abort(.badRequest)
        }
        let user = try req.auth.require(User.self)
        return Acronym.query(on: req.db)
                .filter(\.$user.$id == user.id!)
                .group(.or) { or in
                    or.filter(\.$short ~~ searchTerm)
                    or.filter(\.$long ~~ searchTerm)
                }.all()
                 .flatMapThrowing { acronyms in
                    var acronymsAsPublic: [Acronym.Public] = []
                    for acronym in acronyms {
                        acronymsAsPublic.append(try acronym.asPublic())
                    }
                    return acronymsAsPublic
                 }

    }

    func getFirstHandler(_ req: Request) throws -> EventLoopFuture<Acronym.Public> {
        let user = try req.auth.require(User.self)
        return Acronym.query(on: req.db)
                .filter(\.$user.$id == user.id!)
                .first()
                .unwrap(or: Abort(.notFound))
                .flatMapThrowing { acronym in
                    try acronym.asPublic()
                }
    }

    func sortedHandler(_ req: Request) throws -> EventLoopFuture<[Acronym.Public]> {
        let user = try req.auth.require(User.self)
        return Acronym.query(on: req.db)
                .filter(\.$user.$id == user.id!)
                .sort(\.$short, .ascending)
                .all()
                .flatMapThrowing { acronyms in
                    var acronymsAsPublic: [Acronym.Public] = []
                    for acronym in acronyms {
                        acronymsAsPublic.append(try acronym.asPublic())
                    }
                    return acronymsAsPublic
                }
    }

    func getUserHandler(_ req: Request) throws -> EventLoopFuture<User.Public> {
        guard let acronymID: UUID = req.parameters.get("acronymID", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        return Acronym.find(acronymID, on: req.db)
                .unwrap(or: Abort(.notFound))
                .flatMap{ acronym in
                     acronym.$user.get(on: req.db).flatMapThrowing { user in
                          try user.asPublic()
                     }
                }
    }

    func addCategoriesHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let acronymQuery =
                Acronym.find(req.parameters.get("acronymID"), on: req.db)
                        .unwrap(or: Abort(.notFound))
        let categoryQuery =
                Category.find(req.parameters.get("categoryID"), on: req.db)
                        .unwrap(or: Abort(.notFound))
        return acronymQuery.and(categoryQuery)
                .flatMap { acronym, category in
                    acronym.$categories
                            .attach(category, on: req.db)
                            .transform(to: .created)
                }
    }

    func getCategoriesHandler(_ req: Request) throws -> EventLoopFuture<[Category]> {
        guard let acronymID: UUID = req.parameters.get("acronymID", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        return Acronym.find(acronymID, on: req.db)
                .unwrap(or: Abort(.notFound))
                .flatMap { acronym in
                    acronym.$categories.query(on: req.db).all()
                }
    }

    func removeCategoriesHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let acronymQuery =
                Acronym.find(req.parameters.get("acronymID"), on: req.db)
                        .unwrap(or: Abort(.notFound))
        let categoryQuery =
                Category.find(req.parameters.get("categoryID"), on: req.db)
                        .unwrap(or: Abort(.notFound))
        return acronymQuery.and(categoryQuery)
                .flatMap { acronym, category in
                    acronym.$categories
                            .detach(category, on: req.db)
                            .transform(to: .noContent)
                }
    }
}

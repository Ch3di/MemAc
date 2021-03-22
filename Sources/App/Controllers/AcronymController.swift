import Vapor
import Fluent

struct CreateAcronymData: Content {
    let short: String
    let long: String
    let isPrivate: Bool
}

struct PatchAcronymData: Content {
    let short: String?
    let long: String?
    let isPrivate: Bool?
}


struct AcronymsController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let acronymsRoute = routes.grouped("api", "acronyms")
        acronymsRoute.get("all", use: getAllPublicHandler)
        let acronymsProtectedRoute = acronymsRoute.grouped(JWTAuthenticatorBearer())
        acronymsProtectedRoute.get(use: getAllHandler)
        acronymsProtectedRoute.post(use: createHandler)
        acronymsProtectedRoute.get(":acronymID", use: getHandler)
        acronymsProtectedRoute.patch(":acronymID", use: updateHandler)
        acronymsProtectedRoute.delete(":acronymID", use: deleteHandler)
        acronymsProtectedRoute.get("search", use: searchHandler)
        acronymsProtectedRoute.get("first", use: getFirstHandler)
        acronymsProtectedRoute.get("sorted", use: sortedHandler)
        acronymsRoute.get(":acronymID", "user", use: getUserHandler)
        acronymsProtectedRoute.get(":acronymID", "categories", use: getCategoriesHandler)
        acronymsProtectedRoute.post(":acronymID", "categories", ":categoryID", use: addCategoriesHandler)
        acronymsProtectedRoute.delete(":acronymID", "categories", ":categoryID", use: removeCategoriesHandler)
    }

    func getAllHandler(_ req: Request) throws -> EventLoopFuture<[Acronym.Public]> {
        let user = try req.auth.require(User.self)
        return Acronym.query(on: req.db)
                .filter(\.$user.$id == user.id!)
                .all()
                .flatMapThrowing { acronyms -> [Acronym.Public] in
                    var acronymsAsPublic: [Acronym.Public] = []
                    for acronym in acronyms {
                        acronymsAsPublic.append(try acronym.asPublic())
                    }
                    return acronymsAsPublic
                }
    }

    func getAllPublicHandler(_ req: Request) throws -> EventLoopFuture<[Acronym.Public]> {
        Acronym.query(on: req.db)
                .filter(\.$isPrivate == false)
                .all()
                .flatMapThrowing { acronyms -> [Acronym.Public] in
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
        let acronym = try Acronym(short: data.short, long: data.long, isPrivate: data.isPrivate, userID: user.requireID())
        return acronym.save(on: req.db).flatMapThrowing { try acronym.asPublic() }
    }

    func getHandler(_ req: Request) throws -> EventLoopFuture<Acronym.Public> {
        guard let acronymID: UUID = req.parameters.get("acronymID", as: UUID.self) else {
            throw Abort(IdError.badId.status, reason: IdError.badId.reason)
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
            throw Abort(IdError.badId.status, reason: IdError.badId.reason)

        }
        let patchData = try req.content.decode(PatchAcronymData.self)
        let user = try req.auth.require(User.self)
        return Acronym.query(on: req.db)
                .filter(\.$id == acronymID)
                .filter(\.$user.$id == user.id!)
                .first()
                .unwrap(or: Abort(.unauthorized))
                .flatMap { acronym in
                    acronym.short = patchData.short ?? acronym.short
                    acronym.long = patchData.long ?? acronym.long
                    acronym.isPrivate = patchData.isPrivate ?? acronym.isPrivate
                    return acronym.save(on: req.db).flatMapThrowing {
                        try acronym.asPublic()
                    }
                }
    }

    func deleteHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let acronymID: UUID = req.parameters.get("acronymID", as: UUID.self) else {
            throw Abort(IdError.badId.status, reason: IdError.badId.reason)
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
            throw Abort(IdError.badId.status, reason: IdError.badId.reason)
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
            throw Abort(IdError.badId.status, reason: IdError.badId.reason)
        }
        return Acronym.query(on: req.db)
                .filter(\.$id == acronymID)
                .filter(\.$isPrivate == false)
                .first()
                .unwrap(or: Abort(.notFound))
                .flatMap{ acronym in
                     acronym.$user.get(on: req.db).flatMapThrowing { user in
                          try user.asPublic()
                     }
                }
    }

    func addCategoriesHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let acronymID: UUID = req.parameters.get("acronymID", as: UUID.self) else {
            throw Abort(IdError.badId.status, reason: IdError.badId.reason)
        }
        guard let categoryID: UUID = req.parameters.get("categoryID", as: UUID.self) else {
            throw Abort(IdError.badId.status, reason: IdError.badId.reason)
        }
        let user = try req.auth.require(User.self)
        let acronymQuery = Acronym.query(on: req.db)
                .filter(\.$user.$id == user.id!)
                .filter(\.$id == acronymID)
                .first()
                .unwrap(or: Abort(.notFound, reason: "Acronym does not exist"))
        let categoryQuery = Category.query(on: req.db)
                .filter(\.$user.$id == user.id!)
                .filter(\.$id == categoryID)
                .first()
                .unwrap(or: Abort(.notFound, reason: "Category does not exist"))
        return acronymQuery.and(categoryQuery).flatMap { acronym, category in
            acronym.$categories
                    .attach(category, method: .ifNotExists, on: req.db)
                    .transform(to: .created)
        }
    }

    func getCategoriesHandler(_ req: Request) throws -> EventLoopFuture<[Category.Public]> {
        guard let acronymID: UUID = req.parameters.get("acronymID", as: UUID.self) else {
            throw Abort(IdError.badId.status, reason: IdError.badId.reason)
        }
        let user = try req.auth.require(User.self)
        return Acronym.query(on: req.db)
                .filter(\.$id == acronymID)
                .filter(\.$user.$id == user.id!)
                .first()
                .unwrap(or: Abort(.notFound))
                .flatMap { acronym in
                    acronym.$categories.query(on: req.db)
                           .all()
                           .flatMapThrowing { categories in
                                var categoriesAsPublic: [Category.Public] = []
                                for category in categories {
                                    categoriesAsPublic.append(try category.asPublic())
                                }
                                return categoriesAsPublic
                           }
                }
    }

    func removeCategoriesHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let acronymID: UUID = req.parameters.get("acronymID", as: UUID.self) else {
            throw Abort(IdError.badId.status, reason: IdError.badId.reason)
        }
        guard let categoryID: UUID = req.parameters.get("categoryID", as: UUID.self) else {
            throw Abort(IdError.badId.status, reason: IdError.badId.reason)
        }
        let user = try req.auth.require(User.self)
        let acronymQuery = Acronym.query(on: req.db)
                .filter(\.$user.$id == user.id!)
                .filter(\.$id == acronymID)
                .first()
                .unwrap(or: Abort(.notFound, reason: "Acronym does not exist"))
        let categoryQuery = Category.query(on: req.db)
                .filter(\.$user.$id == user.id!)
                .filter(\.$id == categoryID)
                .first()
                .unwrap(or: Abort(.notFound, reason: "Category does not exist"))
        return acronymQuery.and(categoryQuery)
                            .flatMap { acronym, category in
                                acronym.$categories
                                        .detach(category, on: req.db)
                                        .transform(to: .noContent)
                            }
    }
}

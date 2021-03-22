import Vapor
import FluentPostgresDriver

struct CreateCategoryData: Content {
    let name: String
}

struct CategoriesController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let categoriesRoute = routes.grouped("api", "categories")
        let categoriesProtectedRoute = categoriesRoute.grouped(JWTAuthenticatorBearer())
        categoriesProtectedRoute.post(use: createHandler)
        categoriesProtectedRoute.get(use: getAllHandler)
        categoriesProtectedRoute.get(":categoryID", use: getHandler)
        categoriesProtectedRoute.get(":categoryID", "acronyms", use: getAcronymsHandler)
    }

    func createHandler(_ req: Request)  throws -> EventLoopFuture<Category.Public> {
        let categoryData = try req.content.decode(CreateCategoryData.self)
        let user = try req.auth.require(User.self)
        let category = try Category(name: categoryData.name, userID: user.requireID())
        return category.save(on: req.db).flatMapThrowing {
            try category.asPublic()
        }
    }

    func getAllHandler(_ req: Request) throws -> EventLoopFuture<[Category.Public]> {
        let user = try req.auth.require(User.self)
        return Category.query(on: req.db)
                .filter(\.$user.$id == user.id!)
                .all()
                .flatMapThrowing { categories -> [Category.Public] in
                    var categoriesAsPublic: [Category.Public] = []
                    for category in categories {
                        categoriesAsPublic.append(try category.asPublic())
                    }
                    return categoriesAsPublic
                }
    }


    func getHandler(_ req: Request) throws -> EventLoopFuture<Category.Public> {
        guard let categoryID: UUID = req.parameters.get("categoryID", as: UUID.self) else {
            throw Abort(IdError.badId.status, reason: IdError.badId.reason)
        }
        let user = try req.auth.require(User.self)
        return Category.query(on: req.db)
                .filter(\.$id == categoryID)
                .filter(\.$user.$id == user.id!)
                .first()
                .unwrap(or: Abort(.notFound))
                .flatMapThrowing { category in try category.asPublic() }
    }


    func getAcronymsHandler(_ req: Request) throws -> EventLoopFuture<[Acronym.Public]> {
        guard let categoryID: UUID = req.parameters.get("categoryID", as: UUID.self) else {
            throw Abort(IdError.badId.status, reason: IdError.badId.reason)
        }
        let user = try req.auth.require(User.self)
        return Category.query(on: req.db)
                .filter(\.$id == categoryID)
                .filter(\.$user.$id == user.id!)
                .first()
                .unwrap(or: Abort(.notFound))
                .flatMap { category in
                    category.$acronyms.get(on: req.db).flatMapThrowing { acronyms -> [Acronym.Public] in
                        var acronymsAsPublic: [Acronym.Public] = []
                        for acronym in acronyms {
                            if acronym.$user.id == user.id {
                                acronymsAsPublic.append(try acronym.asPublic())
                            }
                        }
                        return acronymsAsPublic
                    }
                }
    }
}
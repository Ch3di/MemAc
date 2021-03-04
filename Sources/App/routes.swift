import Fluent
import Vapor

func routes(_ app: Application) throws {
    let acronymController = AcronymsController()
    let userController = UsersController()
    let categoriesController = CategoriesController()

    try app.register(collection: acronymController)
    try app.register(collection: userController)
    try app.register(collection: categoriesController)
}

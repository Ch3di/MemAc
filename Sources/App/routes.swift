import Fluent
import Vapor

func routes(_ app: Application) throws {
    let acronymController = AcronymsController()
    let userController = UsersController()
    try app.register(collection: acronymController)
    try app.register(collection: userController)
}

import Fluent
import Vapor

func routes(_ app: Application) throws {
    let acronymController = AcronymsController()
    try app.register(collection: acronymController)
}

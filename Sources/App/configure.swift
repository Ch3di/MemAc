import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    let databaseName: String
    let databasePort: Int = 5432
    if (app.environment == .testing) {
        databaseName = "til_test_db"
    } else {
        databaseName = "til_db"
    }

    app.databases.use(.postgres(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? databasePort,
        username: Environment.get("DATABASE_USERNAME") ?? "postgres",
        password: Environment.get("DATABASE_PASSWORD") ?? "",
        database: Environment.get("DATABASE_NAME") ?? databaseName
    ), as: .psql)


    app.migrations.add(CreateUser())
    app.migrations.add(CreateAcronym())
    app.migrations.add(CreateCategory())
    app.migrations.add(CreateAcronymCategoryPivot())
    app.logger.logLevel = .debug
    try app.autoMigrate().wait()

    // register routes
    try routes(app)
}

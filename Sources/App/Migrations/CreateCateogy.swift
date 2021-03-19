import Fluent
struct CreateCategory: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("categories")
                .id()
                .field("name", .string, .required)
                .field("userID", .uuid, .required, .references("users", "id"))
                .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("categories").delete()
    }
}
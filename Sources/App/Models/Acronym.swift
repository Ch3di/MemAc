import Vapor
import Fluent

final class Acronym: Model {
    struct Public: Content {
        let id: UUID
        let short: String
        let long: String
        let userID: UUID?
    }

    static let schema = "acronyms"

    @ID
    var id: UUID?

    @Field(key: "short")
    var short: String

    @Field(key: "long")
    var long: String

    @Parent(key: "userID")
    var user: User

    @Siblings(
            through: AcronymCategoryPivot.self,
            from: \.$acronym,
            to: \.$category)
    var categories: [Category]

    init() {}

    init(id: UUID? = nil, short: String, long: String, userID: User.IDValue) {
        self.id = id
        self.short = short
        self.long = long
        self.$user.id = userID
    }

    func asPublic() throws -> Public {
        Public(
                id: try requireID(),
                short: short,
                long: long,
                userID: self.$user.id
        )
    }
}

extension Acronym: Content {}
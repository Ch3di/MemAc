import Vapor
import Fluent

final class Acronym: Model {
    struct Public: Content {
        let id: UUID
        let short: String
        let long: String
        let isPrivate: Bool
        let userID: UUID?
    }

    static let schema = "acronyms"

    @ID
    var id: UUID?

    @Field(key: "short")
    var short: String

    @Field(key: "long")
    var long: String

    @Field(key: "private")
    var isPrivate: Bool

    @Parent(key: "userID")
    var user: User

    @Siblings(
            through: AcronymCategoryPivot.self,
            from: \.$acronym,
            to: \.$category)
    var categories: [Category]

    init() {}

    init(id: UUID? = nil, short: String, long: String, isPrivate: Bool, userID: User.IDValue) {
        self.id = id
        self.short = short
        self.long = long
        self.isPrivate = isPrivate
        self.$user.id = userID
    }

    func asPublic() throws -> Public {
        Public(
                id: try requireID(),
                short: short,
                long: long,
                isPrivate: isPrivate,
                userID: self.$user.id
        )
    }
}

extension Acronym: Content {}
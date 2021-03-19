import Fluent
import Vapor

final class Category: Model, Content {
    struct Public: Content {
        let id: UUID
        let name: String
        let userID: UUID?
    }

    static let schema = "categories"

    @ID
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Parent(key: "userID")
    var user: User

    @Siblings(
            through: AcronymCategoryPivot.self,
            from: \.$category,
            to: \.$acronym)
    var acronyms: [Acronym]

    init() {}

    init(id: UUID? = nil, name: String, userID: User.IDValue) {
        self.id = id
        self.name = name
        self.$user.id = userID
    }

    func asPublic() throws -> Public {
        Public(
                id: try requireID(),
                name: name,
                userID: self.$user.id
        )
    }
}

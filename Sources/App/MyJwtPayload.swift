import Vapor
import JWT

struct MyJwtPayload: Authenticatable, JWTPayload {
    var id: UUID?
    var username: String
    var exp: ExpirationClaim

    func verify(using signer: JWTSigner) throws {
        try self.exp.verifyNotExpired()
    }


}

import Vapor

enum UserError {
    case usernameTaken
    case passwordsNotMatch
}

extension UserError: AbortError {
    var description: String {
        reason
    }

    var status: HTTPResponseStatus {
        switch self {
        case .usernameTaken: return .conflict
        case .passwordsNotMatch: return .badRequest
        }
    }

    var reason: String {
        switch self {
        case .usernameTaken: return "Username Already Taken"
        case .passwordsNotMatch: return "Passwords Did Not Match"
        }
    }
}

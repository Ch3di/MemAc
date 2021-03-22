
import Vapor

enum IdError {
    case badId
}

extension IdError: AbortError {
    var description: String {
        reason
    }

    var status: HTTPResponseStatus {
        switch self {
        case .badId: return .badRequest
        }
    }

    var reason: String {
        switch self {
        case .badId: return "Bad ID Format"
        }
    }
}

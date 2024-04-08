import Foundation

/// Represents the HTTP methods used in network requests.
public enum HTTPMethod {
    case get
    case post
    case put
    case delete
    case patch
    case head
    case options
    case trace
    case connect
    case custom(String)
    
    /// The string value of the HTTP method.
    var rawValue: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        case .put: return "PUT"
        case .delete: return "DELETE"
        case .patch: return "PATCH"
        case .head: return "HEAD"
        case .options: return "OPTIONS"
        case .trace: return "TRACE"
        case .connect: return "CONNECT"
        case .custom(let value): return value
        }
    }
}

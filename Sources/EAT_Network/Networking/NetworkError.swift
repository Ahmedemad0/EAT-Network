import Foundation

enum NetworkError: Error, Equatable {
    case invalidURL
    case invalidResponse
    case invalidDecoding
    case invalidEncoding
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case noData
    case server(String)
    case custom(String)
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("The URL is invalid.", comment: "Invalid URL")
        case .invalidResponse:
            return NSLocalizedString("The response is invalid.", comment: "Invalid Response")
        case .invalidDecoding:
            return NSLocalizedString("Failed to decode the response.", comment: "Invalid Decoding")
        case .invalidEncoding:
            return NSLocalizedString("Failed to encode the request.", comment: "Invalid Encoding")
        case .badRequest:
            return NSLocalizedString("Bad request.", comment: "Bad Request")
        case .unauthorized:
            return NSLocalizedString("Unauthorized access.", comment: "Unauthorized")
        case .forbidden:
            return NSLocalizedString("Access is forbidden.", comment: "Forbidden")
        case .notFound:
            return NSLocalizedString("Resource not found.", comment: "Not Found")
        case .noData:
            return NSLocalizedString("No data received.", comment: "No Data")
        case .server(let message):
            return String(format: NSLocalizedString("Server error: %@", comment: "Server Error"), message)
        case .custom(let message):
            return String(format: NSLocalizedString("Error: %@", comment: "Custom Error"), message)
        }
    }
}

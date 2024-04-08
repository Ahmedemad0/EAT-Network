import Foundation

/// The default implementation of the NetworkDispatcher protocol.
public final class DefaultNetworkDispatcher: NetworkDispatcher {
    private let session: URLSessionProtocol

    /// Initializes the DefaultNetworkDispatcher with an optional URLSession instance.
    /// - Parameter session: The URLSession instance to use for network requests. If not provided,
    /// a shared URLSession will be used.
    public init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    public func dispatch<Request: RequestType>(_ request: Request) async throws -> Request.ResponseType {
        let urlRequest = try request.asURLRequest()
        let (data, _) = try await session.data(for: urlRequest)
        return try request.responseDecoder(data)
    }
    
    public func upload<Request: FileRequestType>(_ request: Request) async throws -> Request.ResponseType  {
        
        var urlRequest = try request.asURLRequest()
        let requestData = request.data

        let filename = "name_\(Date().toString()).\(request.mimeType.rawValue)"
        let boundary = "Boundary-\(UUID().uuidString)"

        urlRequest.httpMethod = "POST"
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = createBody(
            boundary: boundary,
            data: requestData,
            mimeType: request.mimeType.rawValue,
            filename: filename
        )

        let (data, _) = try await session.data(for: urlRequest)
        return try request.responseDecoder(data)
    }
}

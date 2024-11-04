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
        let (data, response) = try await session.data(for: urlRequest)
        try handleResponse(response)
        return try request.responseDecoder(data)
    }
    
    public func upload<Request: FilesRequestType>(_ request: Request) async throws -> Request.ResponseType  {
        
        var urlRequest = try request.asURLRequest()

        let boundary = "Boundary-\(UUID().uuidString)"

        urlRequest.httpMethod = request.method.rawValue
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let files = request.files.map { file in
            let fileData = file.data
            let filename = "\(file.fileName)_\(Date().toString()).\(file.mimeType.fileExtension)"
            
            return DefaultFile(
                key: file.key,
                fileName: filename,
                mimeType: file.mimeType,
                data: fileData
            )
        }
        
        urlRequest.httpBody = createBody(
            boundary: boundary,
            files: files,
            parameters: request.bodyParameters
        )

        let (data, response) = try await session.data(for: urlRequest)
        try handleResponse(response)
        return try request.responseDecoder(data)
    }
    
    private func handleResponse(_ response: URLResponse?) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        try handleResponseStatusCode(httpResponse)
    }
    
    private func handleResponseStatusCode(_ httpResponse: HTTPURLResponse) throws {
        switch httpResponse.statusCode {
        case 200...299:
            break
        case 400:
            throw NetworkError.badRequest
        case 401:
            throw NetworkError.unauthorized
        case 403:
            throw NetworkError.forbidden
        case 404:
            throw NetworkError.notFound
        case 500...599:
            throw NetworkError.server("Server Error - \(httpResponse.statusCode) Something went wrong on the server's side.")
        default:
            throw NetworkError.custom("Received HTTP \(httpResponse.statusCode), which was not handled explicitly.")
        }
    }
}

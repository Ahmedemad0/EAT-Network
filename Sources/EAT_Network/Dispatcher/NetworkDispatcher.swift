import Foundation
/// A protocol for dispatching network requests.
public protocol NetworkDispatcher {
    /// Dispatches a network request and returns the response asynchronously.
    /// - Parameters:
    ///   - request: The network request to dispatch.
    /// - Returns: The response from the network request.
    func dispatch<Request: RequestType>(_ request: Request) async throws -> Request.ResponseType

    /**
     Uploads a file request to the network.

     - Parameters:
         - request: The file request to be uploaded.

     - Returns: The response type associated with the request.

     - Throws: An error if the upload operation fails.

     - Note: This function is asynchronous and should be called using the `await` keyword.

     - Requires: The `Request` type must conform to the `FilesRequestType` protocol.
     */
    func upload<Request: FilesRequestType>(_ request: Request) async throws -> Request.ResponseType
}

extension NetworkDispatcher {
    
    /// Creates a multipart form-data body for an HTTP request with specified boundary, files, and parameters.
    ///
    /// - Parameters:
    ///   - boundary: A unique boundary string used to separate parts of the form-data body.
    ///   - files: An array of `FileType` instances representing files to be included in the form-data body.
    ///   - parameters: A dictionary of key-value pairs (`[String: Any]`) representing additional parameters to be included in the form-data body.
    ///
    /// - Returns: A `Data` object representing the multipart form-data body with both files and parameters included.
    func createBody(
        boundary: String,
        files: [FileType],
        parameters: [String: Any]
    ) -> Data {
        let body = NSMutableData()
        let boundaryPrefix = "--\(boundary)\r\n"
    
        // Append parameters to the body
        for (key, value) in parameters {
            body.append(boundaryPrefix)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append("\(value)\r\n")
        }
    
        // Append files to the body
        for file in files {
            body.append(boundaryPrefix)
            body.append("Content-Disposition: form-data; name=\"\(file.key)\"; filename=\"\(file.fileName)\"\r\n")
            body.append("Content-Type: \(file.mimeType.rawValue)\r\n\r\n")
            body.append(file.data)
            body.append("\r\n")
        }
        
        // Final boundary to indicate the end of the form-data body
        body.append("--\(boundary)--\r\n")
        
        return body as Data
    }
}

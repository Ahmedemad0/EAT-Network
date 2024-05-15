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
    /**
     Creates the body of a multipart form-data request.
     
     - Parameters:
        - boundary: The boundary string used to separate different parts of the request body.
        - data: The data to be included in the request body.
        - mimeType: The MIME type of the data.
        - filename: The name of the file being uploaded.
     
     - Returns: The request body as `Data`.
     */
    func createBody(
        boundary: String,
        files: [FileType]
    ) -> Data {
        let body = NSMutableData()
        let boundaryPrefix = "--\(boundary)\r\n"

        for file in files {
            body.append(boundaryPrefix)
            body.append("Content-Disposition: form-data; name=\"\(file.key)\"; filename=\"\(file.fileName)\"\r\n")
            body.append("Content-Type: \(file.mimeType.rawValue)\r\n\r\n")
            body.append(file.data)
            body.append("\r\n")
        }
        
        body.append("--\(boundary)--\r\n")
        return body as Data
    }

}

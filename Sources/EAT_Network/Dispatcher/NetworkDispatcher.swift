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

     - Requires: The `Request` type must conform to the `FileRequestType` protocol.
     */
    func upload<Request: FileRequestType>(_ request: Request) async throws -> Request.ResponseType
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
        key: String,
        data: Data,
        mimeType: String,
        filename: String
    ) -> Data {
        let body = NSMutableData()
        let boundaryPrefix = "--\(boundary)\r\n"

        body.append(boundaryPrefix)
        body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(filename)\"\r\n")
        body.append("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.append("\r\n")
        body.append("--".appending(boundary.appending("--")))

        return body as Data
    }
}

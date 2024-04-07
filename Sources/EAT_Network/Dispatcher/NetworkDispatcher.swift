import Foundation
/// A protocol for dispatching network requests.
public protocol NetworkDispatcher {
    /// Dispatches a network request and returns the response asynchronously.
    /// - Parameters:
    ///   - request: The network request to dispatch.
    /// - Returns: The response from the network request.
    func dispatch<Request: RequestType>(_ request: Request) async throws -> Request.ResponseType
}

extension NetworkDispatcher {
    /// - Parameters:
    ///   - boundary: A parameter used by the server to know where the sent value begins and ends.
    ///   - data: What you send to the server, which can be audio, an image, video, etc.
    ///   - mimeType: : A standardized way to indicate the format of the sent file. You can see various types on this page: MimeTypes
    ///   - filename: The name of the file being sent.
    /// - Returns: Data of file
    func createBody(boundary: String, data: Data, mimeType: String, filename: String) -> Data {
        let body = NSMutableData()
        let boundaryPrefix = "--\(boundary)\r\n"

        body.append(boundaryPrefix)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
        body.append("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.append("\r\n")
        body.append("--".appending(boundary.appending("--")))

        return body as Data
    }
}

import Foundation

public protocol FileType {
    var fileName: String { get }
    var mimeType: MimeType { get }
    var data: Data { get }
}

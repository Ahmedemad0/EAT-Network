import Foundation

/// A protocol representing a file type.
public protocol FileType {
    /**
     Represents a file type with a key.
     
     - Returns: The key associated with the file type.
     */
    var key: String { get }

    /// The name of the file.
    var fileName: String { get }
    
    /// The MIME type of the file.
    var mimeType: MimeType { get }
    
    /// The data of the file.
    var data: Data { get }
}

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

/// A protocol that represents a collection of file types.
public protocol FilesType {
    /// An array of file types.
    var files: [FileType] { get }
}


/// A struct representing a default file.
public struct DefaultFile: FileType {
    /// The key associated with the file.
    public var key: String
    /// The name of the file.
    public var fileName: String
    /// The MIME type of the file.
    public var mimeType: MimeType
    /// The data of the file.
    public var data: Data
}

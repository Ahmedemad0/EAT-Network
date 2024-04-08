/// A typealias that combines the `TargetType` and `ResponseDecoder` protocols.
public typealias RequestType = TargetType & ResponseDecoder

/**
 A type alias that represents a request type that also conforms to the `FileType` protocol.
 
 Use this type alias when you need a request type that can handle file-related operations.
 
 - Note: The `FileType` protocol defines methods and properties for working with files.
 */
public typealias FileRequestType = RequestType & FileType

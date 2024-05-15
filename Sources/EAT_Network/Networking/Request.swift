/// A typealias that combines the `TargetType` and `ResponseDecoder` protocols.
public typealias RequestType = TargetType & ResponseDecoder


/**
 A type alias that represents a request type that also supports file handling.

 This typealias combines the `RequestType` protocol and the `FilesType` protocol to create a new type that can handle both regular network requests and file uploads.

 - Note: This typealias is used to define the `FilesRequestType` in the EAT_Network module.

 - SeeAlso:
     - `RequestType`
     - `FilesType`
 */
public typealias FilesRequestType = RequestType & FilesType

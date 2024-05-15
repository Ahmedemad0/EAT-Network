import Foundation
import XCTest
@testable import EAT_Network

// swiftlint:disable force_unwrapping
final class DefaultNetworkDispatcherTests: XCTestCase {

    // MARK: - Mock Types

    private struct MockRequest: RequestType {
        let baseUrl: URL = URL(string: "https://example.com")!
        let path: String = "/api/endpoint"
        let method: HTTPMethod = .get
        let parameters: [String: String] = [:]

        let responseDecoder: (Data) throws -> Int = { data in
            guard let responseString = String(data: data, encoding: .utf8),
                  let responseInt = Int(responseString) else {
                throw NetworkError.invalidResponse
            }
            return responseInt
        }
    }
    
    private struct MockFileRequest: FilesRequestType {
        var files: [FileType] = [
            DefaultFile(
                key: "MockKey",
                fileName: "FileName",
                mimeType: .png,
                data: Data()
            )
        ]
        let baseUrl: URL = URL(string: "https://example.com")!
        let path: String = "/api/endpoint"
        let method: HTTPMethod = .post
        
        let responseDecoder: (Data) throws -> Int = { data in
            guard let responseString = String(data: data, encoding: .utf8),
                  let responseInt = Int(responseString) else {
                throw NetworkError.invalidResponse
            }
            return responseInt
        }
    }

    // MARK: - Tests

    func testDispatchWithValidRequest() async {
        // Given
        let request = MockRequest()
        let mockData = "42".data(using: .utf8)!
        let mockURLResponse = HTTPURLResponse(
            url: request.baseUrl,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil)!
        let mockSession = URLSessionMock(result: .success((mockData, mockURLResponse)))
        let networkDispatcher = DefaultNetworkDispatcher(session: mockSession)

        // When
        let result = try? await networkDispatcher.dispatch(request)

        // Then
        XCTAssertEqual(result, 42)
    }

    func testDispatchWithInvalidResponse() async throws {
        // Given
        let request = MockRequest()
        let mockData = "invalid".data(using: .utf8)!
        let mockURLResponse = HTTPURLResponse(
            url: request.baseUrl,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil)!
        let mockSession = URLSessionMock(result: .success((mockData, mockURLResponse)))
        let networkDispatcher = DefaultNetworkDispatcher(session: mockSession)

        // When/Then
        // When
        var thrownError: Error?
        do {
            _ = try await networkDispatcher.dispatch(request)
        } catch {
            thrownError = error
        }

        // Then
        XCTAssertEqual(thrownError as? NetworkError, NetworkError.invalidResponse)
    }

    func testDispatchWithNetworkError() async {
        // Given
        let request = MockRequest()
        let mockError = NSError(domain: "TestErrorDomain", code: 123, userInfo: nil)
        let mockSession = URLSessionMock(result: .failure(mockError))
        let networkDispatcher = DefaultNetworkDispatcher(session: mockSession)

        // When
        var thrownError: Error?
        do {
            _ = try await networkDispatcher.dispatch(request)
        } catch {
            thrownError = error
        }

        // Then
        XCTAssertEqual(thrownError as? NSError, mockError)
    }
    
    func testUploadWithValidRequest() async {
        // Given
        let request = MockFileRequest()
        let mockData = "42".data(using: .utf8)!
        let mockURLResponse = HTTPURLResponse(
            url: request.baseUrl,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil)!
        let mockSession = URLSessionMock(result: .success((mockData, mockURLResponse)))
        let networkDispatcher = DefaultNetworkDispatcher(session: mockSession)

        // When
        let result = try? await networkDispatcher.upload(request)

        // Then
        XCTAssertEqual(result, 42)
    }
    
    func testCreateBodyForOneFileRequest() {
        // Given
        let request = MockFileRequest()
        let mockData = "42".data(using: .utf8)!
        let mockURLResponse = HTTPURLResponse(
            url: request.baseUrl,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil)!
        let mockSession = URLSessionMock(result: .success((mockData, mockURLResponse)))
        let networkDispatcher = DefaultNetworkDispatcher(session: mockSession)

        // When
        let uuid = UUID().uuidString
        let boundary = "Boundary-\(uuid)"
        let body = networkDispatcher.createBody(
            boundary: boundary,
            files: request.files
        )

        // Then
        let bodyString = String(data: body, encoding: .utf8)!
        XCTAssertTrue(bodyString.contains("Boundary-\(uuid)"))
        XCTAssertTrue(bodyString.contains("Content-Disposition: form-data; name=\"\(request.files[0].key)\"; filename=\"\(request.files[0].fileName)\""))
        XCTAssertTrue(bodyString.contains("Content-Type: \(request.files[0].mimeType.rawValue)"))
    }

    func testUploadingMultipleFilesRequest() {
        // Given
        var request = MockFileRequest()
        request.files.append(
            DefaultFile(
                key: "MockKey2",
                fileName: "FileName2",
                mimeType: .jpeg,
                data: Data()
            )
        )
        let mockData = "42".data(using: .utf8)!
        let mockURLResponse = HTTPURLResponse(
            url: request.baseUrl,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil)!
        let mockSession = URLSessionMock(result: .success((mockData, mockURLResponse)))
        let networkDispatcher = DefaultNetworkDispatcher(session: mockSession)

        // When
        let uuid = UUID().uuidString
        let boundary = "Boundary-\(uuid)"
        let body = networkDispatcher.createBody(
            boundary: boundary,
            files: request.files
        )

        // Then
        let bodyString = String(data: body, encoding: .utf8)!
        XCTAssertTrue(bodyString.contains("Boundary-\(uuid)"))
        XCTAssertTrue(bodyString.contains("Content-Disposition: form-data; name=\"\(request.files[0].key)\"; filename=\"\(request.files[0].fileName)\""))
        XCTAssertTrue(bodyString.contains("Content-Type: \(request.files[0].mimeType.rawValue)"))
        XCTAssertTrue(bodyString.contains("Content-Disposition: form-data; name=\"\(request.files[1].key)\"; filename=\"\(request.files[1].fileName)\""))
        XCTAssertTrue(bodyString.contains("Content-Type: \(request.files[1].mimeType.rawValue)"))
    }
    
    // MARK: - Mock URLSession

    private struct URLSessionMock: URLSessionProtocol {
        let result: Result<(data: Data, response: URLResponse), Error>

        func data(for request: URLRequest) async throws -> (Data, URLResponse) {
            switch result {
            case let .success(value):
                return value
            case let .failure(error):
                throw error
            }
        }
    }
}
// swiftlint:enable force_unwrapping


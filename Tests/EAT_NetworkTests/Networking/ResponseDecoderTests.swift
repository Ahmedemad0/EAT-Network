//
//  ResponseDecoderTests.swift
//  
//
//  Created by Ahmed Attalla on 08/04/2024.
//

import XCTest
@testable import EAT_Network

final class ResponseDecoderTests: XCTestCase {
    
    private struct MockResponseDecoder: ResponseDecoder {
        typealias ResponseType = Int
    }
    
    func testDefaultResponseDecoder() {
        // Given
        let data = "42".data(using: .utf8)!

        // When
        let responseDecoder = MockResponseDecoder().responseDecoder

        // Then
        XCTAssertNoThrow(try responseDecoder(data))
        XCTAssertEqual(try? responseDecoder(data), 42)
    }

    func testThrowingResponseDecoder() {
        // Given
        let data = "Not an integer".data(using: .utf8)!

        // When
        let responseDecoder = MockResponseDecoder().responseDecoder

        // Then
        XCTAssertThrowsError(try responseDecoder(data))
    }
}

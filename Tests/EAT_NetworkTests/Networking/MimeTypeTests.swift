import XCTest
@testable import EAT_Network

final class MimeTypeTests: XCTestCase {
    
    func testMimeTypeRawValues() {
        XCTAssertEqual(MimeType.pdf.rawValue, "application/pdf")
        XCTAssertEqual(MimeType.png.rawValue, "image/png")
        XCTAssertEqual(MimeType.jpeg.rawValue, "image/jpeg")
        XCTAssertEqual(MimeType.gif.rawValue, "image/gif")
        XCTAssertEqual(MimeType.bmp.rawValue, "image/bmp")
        XCTAssertEqual(MimeType.svg.rawValue, "image/svg+xml")
        XCTAssertEqual(MimeType.mp4.rawValue, "video/mp4")
        XCTAssertEqual(MimeType.mov.rawValue, "video/quicktime")
        XCTAssertEqual(MimeType.avi.rawValue, "video/x-msvideo")
        XCTAssertEqual(MimeType.mkv.rawValue, "video/x-matroska")
        XCTAssertEqual(MimeType.webm.rawValue, "video/webm")
        XCTAssertEqual(MimeType.wav.rawValue, "audio/wav")
        XCTAssertEqual(MimeType.mp3.rawValue, "audio/mpeg")
        XCTAssertEqual(MimeType.ogg.rawValue, "audio/ogg")
        XCTAssertEqual(MimeType.flac.rawValue, "audio/flac")
        XCTAssertEqual(MimeType.txt.rawValue, "text/plain")
        XCTAssertEqual(MimeType.html.rawValue, "text/html")
        XCTAssertEqual(MimeType.css.rawValue, "text/css")
        XCTAssertEqual(MimeType.js.rawValue, "application/javascript")
        XCTAssertEqual(MimeType.json.rawValue, "application/json")
        XCTAssertEqual(MimeType.xml.rawValue, "application/xml")
        XCTAssertEqual(MimeType.csv.rawValue, "text/csv")
        XCTAssertEqual(MimeType.doc.rawValue, "application/msword")
        XCTAssertEqual(MimeType.docx.rawValue, "application/vnd.openxmlformats-officedocument.wordprocessingml.document")
        XCTAssertEqual(MimeType.ppt.rawValue, "application/vnd.ms-powerpoint")
        XCTAssertEqual(MimeType.pptx.rawValue, "application/vnd.openxmlformats-officedocument.presentationml.presentation")
        XCTAssertEqual(MimeType.xls.rawValue, "application/vnd.ms-excel")
        XCTAssertEqual(MimeType.xlsx.rawValue, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
        XCTAssertEqual(MimeType.zip.rawValue, "application/zip")
        XCTAssertEqual(MimeType.rar.rawValue, "application/vnd.rar")
        XCTAssertEqual(MimeType.tar.rawValue, "application/x-tar")
    }
    
    func testCustomMimeTypeRawValue() {
        let customType = "application/custom"
        let mimeType = MimeType.custom(customType)
        XCTAssertEqual(mimeType.rawValue, customType)
    }
}

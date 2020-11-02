
import XCTest
@testable import ThumbnailApp

class ThumbnailAppTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testDecodingOneThumbnail() {
        let json = """
            {
                "imageUrl": "https://mnktechnology.com/tech/mytester/web/images/road-1072823_1280.jpg",
                "caption": "Autumn Path"
            }
        """.data(using: .utf8)!
        
        let data = try! JSONDecoder().decode(ThumbnailInfo.self, from: json)
        
        XCTAssertEqual(data.imageUrl, "https://mnktechnology.com/tech/mytester/web/images/road-1072823_1280.jpg")
        XCTAssertEqual(data.caption, "Autumn Path")
    }
    
    func testDecodingMultpleThumbnails() {
        let json = """
            [
                {
                    "imageUrl": "https://mnktechnology.com/tech/mytester/web/images/road-1072823_1280.jpg",
                    "caption": "Autumn Path"
                },
                {
                    "imageUrl": "https://mnktechnology.com/tech/mytester/web/images/sunset-3325080_1280.jpg",
                    "caption": "Sunset Ray"
                }
            ]
        """.data(using: .utf8)!
        
        let data = try! JSONDecoder().decode([ThumbnailInfo].self, from: json)
        XCTAssertEqual(data.count, 2)
    }
    
    func testDecodingMissingImageUrl() {
        let json = """
            {
                "caption": "Autumn Path"
            }
        """.data(using: .utf8)!
        
        assertThrowsKeyNotFound("imageUrl", decoding: ThumbnailInfo.self, from: json)
    }
    
    func testDecodingMissingCaption() {
        let json = """
            {
                "imageUrl": "https://mnktechnology.com/tech/mytester/web/images/road-1072823_1280.jpg",
            }
        """.data(using: .utf8)!
        
        assertThrowsKeyNotFound("caption", decoding: ThumbnailInfo.self, from: json)
    }
    
    func assertThrowsKeyNotFound<T: Decodable>(_ expectedKey: String, decoding: T.Type, from data: Data) {
        XCTAssertThrowsError(try JSONDecoder().decode(decoding, from: data)) { error in
            if case .keyNotFound(let key, _)? = error as? DecodingError {
                XCTAssertEqual(expectedKey, key.stringValue, "Expected missing key '\(key.stringValue)' to equal '\(expectedKey)'.")
            } else {
                XCTFail("Expected '.keyNotFound(\(expectedKey))' but got \(error)")
            }
        }
    }
    

}

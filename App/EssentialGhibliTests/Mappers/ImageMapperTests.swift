//
//  ImageMapperTests.swift
//  EssentialGhibliTests
//
//  Created by Igor Malyarov on 14.10.2022.
//

@testable import EssentialGhibli
import SwiftUI
import XCTest

final class ImageMapperTests: XCTestCase {
    let record = false
    
    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let json = Data.greenImage(width: 1, height: 2)
        let codes = [199, 201, 300, 400, 500]
        
        try codes.forEach { code in
            XCTAssertThrowsError(
                try ImageMapper.map(dataResponse: (json, .init(statusCode: code)))
            )
        }
    }
    
    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() {
        let invalidJSON = Data("invalid json".utf8)
        
        XCTAssertThrowsError(
            try ImageMapper.map(dataResponse: (invalidJSON, .statusCode200))
        ) {
            XCTAssertEqual($0 as? MappingError, .invalidData)
        }
    }
    
    func test_map_deliversImageOn200HTTPResponseWithJSON() throws {
        let data = Data.uiImageData(withColor: .orange, width: 20, height: 30)
        
        let result = try ImageMapper.map(dataResponse: (data, .statusCode200))
        
        assert(snapshot: result, locale: .en_US, record: record)
    }
}

private extension Data {
    static func greenImage(width: Int, height: Int) -> Data {
        uiImageData(withColor: .green, width: width, height: height)
    }
    
    static func uiImageData(
        withColor color: UIColor,
        width: Int,
        height: Int
    ) -> Data {
        UIImage.make(withColor: color, width: width, height: height).pngData()!
    }
}

private extension UIImage {
    static func make(
        withColor color: UIColor,
        width: Int = 1,
        height: Int = 1
    ) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}

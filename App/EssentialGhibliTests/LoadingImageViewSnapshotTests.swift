//
//  LoadingImageViewSnapshotTests.swift
//  EssentialGhibliTests
//
//  Created by Igor Malyarov on 13.10.2022.
//

import Combine
@testable import EssentialGhibli
import SnapshotTesting
import SwiftUI
import XCTest

final class LoadingImageViewSnapshotTests: XCTestCase {
    let record = false
    
    func test_snapshot_LoadingImageView_loading() {
        let sut = makeSUT {
            self.loader()
                .delay(for: 0.02, scheduler: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
        
        assert(snapshot: sut, locale: .en_US, record: record)
        assert(snapshot: sut, locale: .ru_RU, record: record)
    }
    
    func test_snapshot_LoadingImageView_loaded() {
        let sut = makeSUT(loader: loader)
        
        assert(snapshot: sut, locale: .en_US, record: record)
    }
    
    func test_snapshot_LoadingImageView_loadedFramed() {
        let sut = makeSUT(loader: loader)
            .frame(width: 400, height: 300)
        
        assert(snapshot: sut, locale: .en_US, record: record)
    }
    
    func test_snapshot_LoadingImageView_non200() {
        let sut = makeSUT(loader: non200Loader)

        assert(snapshot: sut, locale: .en_US, record: record)
    }

    func test_snapshot_LoadingImageView_failing() {
        let sut = makeSUT(loader: failingLoader)

        assert(snapshot: sut, locale: .en_US, record: record)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        loader: @escaping () -> ImagePublisher,
        file: StaticString = #file,
        line: UInt = #line
    ) -> some View {
        let loader = loader
        let sut = LoadingImageView(loader: loader)
        
        return sut
    }
    
    private func loader() -> ImagePublisher {
        Just((.greenImage(width: 300, height: 600), .any200))
            .tryMap(ImageMapper.map)
            .eraseToAnyPublisher()
    }
    
    private func non200Loader() -> ImagePublisher {
        Just((.greenImage(width: 300, height: 600), .any400))
            .tryMap(ImageMapper.map)
            .eraseToAnyPublisher()
    }
    
    private func failingLoader() -> ImagePublisher {
        Fail<DataResponse, Error>(error: anyError())
            .tryMap(ImageMapper.map)
            .eraseToAnyPublisher()
    }
    
}

private extension Locale {
    static let en_US: Self = .init(identifier: "en-US")
    static let ru_RU: Self = .init(identifier: "ru-RU")
}

private extension Data {
    static let empty: Self = Data("".utf8)
    
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

private extension HTTPURLResponse {
    static let any200: HTTPURLResponse = .init(url: .anyURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
    static let any400: HTTPURLResponse = .init(url: .anyURL, statusCode: 400, httpVersion: nil, headerFields: nil)!
}

private extension URL {
    static let anyURL: URL = .init(string: "https://any-url.com")!
}

private func anyError(message: String = "any error") -> Error {
    AnyError(message: message)
}

private struct AnyError: Error {
    let message: String
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

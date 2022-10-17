//
//  LoadingImageViewSnapshotTests.swift
//
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
    
    func test_shouldShowLoading_onImageLoading() {
        let sut = makeSUT(loader: longLoader)
        
        assert(snapshot: sut, locale: .en_US, record: record)
        assert(snapshot: sut, locale: .ru_RU, record: record)
    }
    
    func test_shouldShowImage_onLoadedImage() {
        let sut = makeSUT(loader: loader)
        
        assert(snapshot: sut, locale: .en_US, record: record)
    }
    
    func testShouldShowFramedImage_onLoadedImage() {
        let sut = makeSUT(loader: loader)
            .frame(width: 400, height: 300)
        
        assert(snapshot: sut, locale: .en_US, record: record)
    }
    
    func test_shouldShowError_onNon200Response() {
        let sut = makeSUT(loader: non200Loader)
        
        assert(snapshot: sut, locale: .en_US, record: record)
    }
    
    func test_shouldShowError_onFailedImageLoading() {
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
        Just((.uiImageData(withColor: .green, width: 300, height: 600), .statusCode200))
            .tryMap(ImageMapper.map)
            .eraseToAnyPublisher()
    }
    
    private func longLoader() -> ImagePublisher {
        loader()
            .delay(for: 0.02, scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func non200Loader() -> ImagePublisher {
        Just((.uiImageData(withColor: .green, width: 300, height: 600), .statusCode400))
            .tryMap(ImageMapper.map)
            .eraseToAnyPublisher()
    }
    
    private func failingLoader() -> ImagePublisher {
        Fail<DataResponse, Error>(error: anyError())
            .tryMap(ImageMapper.map)
            .eraseToAnyPublisher()
    }
}

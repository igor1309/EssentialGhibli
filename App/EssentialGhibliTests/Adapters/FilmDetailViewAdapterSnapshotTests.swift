//
//  FilmDetailViewAdapterSnapshotTests.swift
//  EssentialGhibliTests
//
//  Created by Igor Malyarov on 14.10.2022.
//

@testable import EssentialGhibli
import XCTest

final class FilmDetailViewAdapterSnapshotTests: XCTestCase {
    let record = false
    
    func test_snapshot_FilmDetailViewAdapter_loaded() {
        let sut = filmDetailViewAdapter(
            loader: filmDetailLoader,
            imageLoader: filmDetailLImageLoader
        )
        
        assert(snapshot: sut, locale: .en_US, record: record)
    }
    
    func test_snapshot_FilmDetailViewAdapter_loading() {
        let sut = filmDetailViewAdapter(
            loader: filmDetailLongLoader,
            imageLoader: filmDetailLImageLoader
        )
        
        assert(snapshot: sut, locale: .en_US, record: record)
        assert(snapshot: sut, locale: .ru_RU, record: record)
    }
    
    func test_snapshot_FilmDetailViewAdapter_loaderFailed() {
        let sut = filmDetailViewAdapter(
            loader: filmDetailLFailingLoader,
            imageLoader: filmDetailLImageLoader
        )
        
        assert(snapshot: sut, locale: .en_US, record: record)
    }
    
    func test_snapshot_FilmDetailViewAdapter_imageLoading() {
        let sut = filmDetailViewAdapter(
            loader: filmDetailLoader,
            imageLoader: filmDetailLLongImageLoader
        )
        
        assert(snapshot: sut, locale: .en_US, record: record)
    }
    
    func test_snapshot_FilmDetailViewAdapter_imageLoaderFailed() {
        let sut = filmDetailViewAdapter(
            loader: filmDetailLoader,
            imageLoader: filmDetailLFailingImageLoader
        )
        
        assert(snapshot: sut, locale: .en_US, record: record)
    }
}

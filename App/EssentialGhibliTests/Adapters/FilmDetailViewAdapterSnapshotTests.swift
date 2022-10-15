//
//  FilmDetailViewAdapterSnapshotTests.swift
//
//
//  Created by Igor Malyarov on 14.10.2022.
//

@testable import EssentialGhibli
import XCTest

final class FilmDetailViewAdapterSnapshotTests: XCTestCase {
    let record = false
    
    func test_snapshot_FilmDetailViewAdapter_loaded() {
        let sut = filmDetailViewAdapter(
            loader: PreviewLoaders.detailFilmLoader,
            imageLoader: PreviewLoaders.detailFilmImageLoader
        )
        
        assert(snapshot: sut, locale: .en_US, record: record)
    }
    
    func test_snapshot_FilmDetailViewAdapter_loading() {
        let sut = filmDetailViewAdapter(
            loader: PreviewLoaders.filmDetailLongLoader,
            imageLoader: PreviewLoaders.detailFilmImageLoader
        )
        
        assert(snapshot: sut, locale: .en_US, record: record)
        assert(snapshot: sut, locale: .ru_RU, record: record)
    }
    
    func test_snapshot_FilmDetailViewAdapter_loaderFailed() {
        let sut = filmDetailViewAdapter(
            loader: PreviewLoaders.failingDetailFilmLoader,
            imageLoader: PreviewLoaders.detailFilmImageLoader
        )
        
        assert(snapshot: sut, locale: .en_US, record: record)
    }
    
    func test_snapshot_FilmDetailViewAdapter_imageLoading() {
        let sut = filmDetailViewAdapter(
            loader: PreviewLoaders.detailFilmLoader,
            imageLoader: PreviewLoaders.longDetailFilmImageLoader
        )
        
        assert(snapshot: sut, locale: .en_US, record: record)
    }
    
    func test_snapshot_FilmDetailViewAdapter_imageLoaderFailed() {
        let sut = filmDetailViewAdapter(
            loader: PreviewLoaders.detailFilmLoader,
            imageLoader: PreviewLoaders.failingDetailFilmImageLoader
        )
        
        assert(snapshot: sut, locale: .en_US, record: record)
    }
}

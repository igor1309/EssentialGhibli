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
    
    func test_shouldShowDetail_onLoadedDetail() {
        let sut = filmDetailViewAdapter(
            loader: PreviewLoaders.detailFilmLoader,
            imageLoader: PreviewLoaders.detailFilmImageLoader
        )
        
        assert(snapshot: sut, locale: .en_US, record: record)
    }
    
    func test_shouldShowLoading_onDetailLoading() {
        let sut = filmDetailViewAdapter(
            loader: PreviewLoaders.filmDetailLongLoader,
            imageLoader: PreviewLoaders.detailFilmImageLoader
        )
        
        assert(snapshot: sut, locale: .en_US, record: record)
        assert(snapshot: sut, locale: .ru_RU, record: record)
    }
    
    func test_shouldShowError_onFailingDetailLoader() {
        let sut = filmDetailViewAdapter(
            loader: PreviewLoaders.failingDetailFilmLoader,
            imageLoader: PreviewLoaders.detailFilmImageLoader
        )
        
        assert(snapshot: sut, locale: .en_US, record: record)
    }
    
    func test_shouldShowLoadingImage_onImageLoading() {
        let sut = filmDetailViewAdapter(
            loader: PreviewLoaders.detailFilmLoader,
            imageLoader: PreviewLoaders.longDetailFilmImageLoader
        )
        
        assert(snapshot: sut, locale: .en_US, record: record)
    }
    
    func test_shouldShowError_onFailingImageLoader() {
        let imageLoader = PreviewLoaders.failingDetailFilmImageLoader
        let sut = filmDetailViewAdapter(
            loader: PreviewLoaders.detailFilmLoader,
            imageLoader: imageLoader
        )
        
        assert(snapshot: sut, locale: .en_US, record: record)
    }
}

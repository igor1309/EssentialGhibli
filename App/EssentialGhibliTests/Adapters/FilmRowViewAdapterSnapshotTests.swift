//
//  FilmRowViewAdapterSnapshotTests.swift
//
//
//  Created by Igor Malyarov on 14.10.2022.
//

@testable import EssentialGhibli
import XCTest

final class FilmRowViewAdapterSnapshotTests: XCTestCase {
    let record = false
    
    func test_snapshot_FilmRowViewAdapter_imageLoaded() {
        let sut = filmRowViewAdapter(PreviewLoaders.filmRowImageLoader)
        
        assert(snapshot: sut, locale: .en_US, record: record)
    }
    
    func test_snapshot_FilmRowViewAdapter_imageLoading() {
        let sut = filmRowViewAdapter(PreviewLoaders.longFilmRowImageLoader)
        
        assert(snapshot: sut, locale: .en_US, record: record)
    }
    
    func test_snapshot_FilmRowViewAdapter_imageLoadingFailed() {
        let sut = filmRowViewAdapter(PreviewLoaders.failingFilmRowImageLoader)
        
        assert(snapshot: sut, locale: .en_US, record: record)
    }
}

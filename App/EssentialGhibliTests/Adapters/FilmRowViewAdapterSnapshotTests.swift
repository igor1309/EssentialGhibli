//
//  FilmRowViewAdapterSnapshotTests.swift
//  EssentialGhibliTests
//
//  Created by Igor Malyarov on 14.10.2022.
//

@testable import EssentialGhibli
import XCTest

final class FilmRowViewAdapterSnapshotTests: XCTestCase {
    let record = false
    
    func test_snapshot_FilmRowViewAdapter_imageLoaded() {
        let sut = filmRowViewAdapter(filmRowImageLoader)
        
        assert(snapshot: sut, locale: .en_US, record: record)
    }
    
    func test_snapshot_FilmRowViewAdapter_imageLoading() {
        let sut = filmRowViewAdapter(longFilmRowImageLoader)
        
        assert(snapshot: sut, locale: .en_US, record: record)
    }
    
    func test_snapshot_FilmRowViewAdapter_imageLoadingFailed() {
        let sut = filmRowViewAdapter(failingFilmRowImageLoader)
        
        assert(snapshot: sut, locale: .en_US, record: record)
    }
}

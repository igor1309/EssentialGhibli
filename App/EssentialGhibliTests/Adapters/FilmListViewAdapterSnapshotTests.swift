//
//  FilmListViewAdapterSnapshotTests.swift
//
//
//  Created by Igor Malyarov on 14.10.2022.
//

@testable import EssentialGhibli
import XCTest

final class FilmListViewAdapterSnapshotTests: XCTestCase {
    let record = false

    func test_shouldShowEmptyList_onEmptyLoader() {
        let sut = filmListViewAdapter(PreviewLoaders.emptyListFilmsLoader)
        
        assert(snapshot: sut, locale: .en_US, record: record)
        assert(snapshot: sut, locale: .ru_RU, record: record)
    }
    
    func test_shouldShowEmptyList_onEmptyLoaderComposer() {
        let sut = filmListViewAdapter(LoaderComposer.empty)
        
        assert(snapshot: sut, locale: .en_US, record: record)
        assert(snapshot: sut, locale: .ru_RU, record: record)
    }
    
    func test_shouldShowFilmList_onSuccessLoader() {
        let sut = filmListViewAdapter(PreviewLoaders.listFilmsLoader)
        
        assert(snapshot: sut, locale: .en_US, record: record)
    }
    
    func test_shouldShowFilmList_onOnlineLoader() {
        let sut = filmListViewAdapter(LoaderComposer.online)
        
        assert(snapshot: sut, locale: .en_US, record: record)
    }

    func test_shouldShowLoading_onLongLoader() {
        let sut = filmListViewAdapter(PreviewLoaders.longListFilmsLoader)
        
        assert(snapshot: sut, locale: .en_US, record: record)
        assert(snapshot: sut, locale: .ru_RU, record: record)
    }
    
    func test_shouldShowLoading_onLongOnlineLoader() {
        let sut = filmListViewAdapter(LoaderComposer.online.longFilmsLoader)
        
        assert(snapshot: sut, locale: .en_US, record: record)
        assert(snapshot: sut, locale: .ru_RU, record: record)
    }
        
    func test_shouldShowError_onFailingLoader() {
        let sut = filmListViewAdapter(PreviewLoaders.failingListFilmsLoader)
        
        assert(snapshot: sut, locale: .en_US, record: record)
        assert(snapshot: sut, locale: .ru_RU, record: record)
    }
}

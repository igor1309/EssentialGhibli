//
//  FilmListViewAdapterSnapshotTests.swift
//  EssentialGhibliTests
//
//  Created by Igor Malyarov on 14.10.2022.
//

@testable import EssentialGhibli
import XCTest

final class FilmListViewAdapterSnapshotTests: XCTestCase {
    let record = false
    
    func test_snapshot_FilmListViewAdapter_nonEmptyList() {
        let sut = filmListViewAdapter(listFilmsLoader)
        
        assert(snapshot: sut, locale: .en_US, record: record)
    }
    
    func test_snapshot_FilmListViewAdapter_emptyList() {
        let sut = filmListViewAdapter(emptyListFilmsLoader)
        
        assert(snapshot: sut, locale: .en_US, record: record)
        assert(snapshot: sut, locale: .ru_RU, record: record)
    }
    
    func test_snapshot_FilmListViewAdapter_loading() {
        let sut = filmListViewAdapter(longListFilmsLoader)
        
        assert(snapshot: sut, locale: .en_US, record: record)
        assert(snapshot: sut, locale: .ru_RU, record: record)
    }
    
    func test_snapshot_FilmListViewAdapter_failed() {
        let sut = filmListViewAdapter(failingListFilmsLoader)
        
        assert(snapshot: sut, locale: .en_US, record: record)
    }
}

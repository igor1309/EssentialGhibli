//
//  FilmListViewSnapshotTests.swift
//  
//
//  Created by Igor Malyarov on 06.10.2022.
//

import ListFeature
import SwiftUI
import XCTest

final class FilmListViewSnapshotTests: XCTestCase {
    let record = false
    
    func test_snapshot_FilmListView_loading() {
        let view = filmListView(.loading)
        
        assert(snapshot: view, locale: .en_US, record: record)
        assert(snapshot: view, locale: .ru_RU, record: record)
    }
    
    func test_snapshot_FilmListView_empty() {
        let view = filmListView(.empty)
        
        assert(snapshot: view, locale: .en_US, record: record)
        assert(snapshot: view, locale: .ru_RU, record: record)
    }
    
    func test_snapshot_FilmListView_list() {
        let view = filmListView(.list([.castleInTheSky, .kikisDeliveryService]))
        
        assert(snapshot: view, locale: .en_US, record: record)
        assert(snapshot: view, locale: .ru_RU, record: record)
    }
    
    func test_snapshot_FilmListView_error() {
        let view = filmListView(.error(anyError()))
        
        assert(snapshot: view, locale: .en_US, record: record)
        assert(snapshot: view, locale: .ru_RU, record: record)
    }
    
    // MARK: - Helpers
    
    let filmListView = { listState in
        NavigationView {
            FilmListView(listState: listState) {
                Text($0.title)
            }
        }
    }
}

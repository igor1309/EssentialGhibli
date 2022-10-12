//
//  ListFeatureSnapshotTests.swift
//  
//
//  Created by Igor Malyarov on 06.10.2022.
//

import ListFeature
import SwiftUI
import XCTest

final class ListFeatureSnapshotTests: XCTestCase {
    let record = false
    
    func test_snapshotGhibliListView_loading() {
        let view = ghibliListView(.loading)
        
        assert(snapshot: view, locale: .en_US, record: record)
        assert(snapshot: view, locale: .ru_RU, record: record)
    }
    
    func test_snapshotGhibliListView_empty() {
        let view = ghibliListView(.empty)
        
        assert(snapshot: view, locale: .en_US, record: record)
        assert(snapshot: view, locale: .ru_RU, record: record)
    }
    
    func test_snapshotGhibliListView_list() {
        let view = ghibliListView(.list([.castleInTheSky, .kikisDeliveryService]))
        
        assert(snapshot: view, locale: .en_US, record: record)
        assert(snapshot: view, locale: .ru_RU, record: record)
    }
    
    func test_snapshotGhibliListView_error() {
        let view = ghibliListView(.error(APIError()))
        
        assert(snapshot: view, locale: .en_US, record: record)
        assert(snapshot: view, locale: .ru_RU, record: record)
    }
    
    // MARK: - Helpers
    
    let ghibliListView = { listState in
        NavigationView {
            FilmListView(listState: listState) {
                Text($0.title)
            }
        }
    }
}
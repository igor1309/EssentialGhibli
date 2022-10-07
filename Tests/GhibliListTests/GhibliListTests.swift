//
//  GhibliListTests.swift
//  
//
//  Created by Igor Malyarov on 06.10.2022.
//

import GhibliList
import SwiftUI
import XCTest

final class GhibliListTests: XCTestCase {
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
            GhibliListView(listState: listState) {
                Text($0.title)
            }
        }
    }
}

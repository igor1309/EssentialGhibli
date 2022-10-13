//
//  ResourceStateViewSnapshotTests.swift
//  
//
//  Created by Igor Malyarov on 07.10.2022.
//

import GenericResourceView
import Presentation
import SwiftUI
import XCTest

final class ResourceStateViewSnapshotTests: XCTestCase {
    let record = false
    
    func test_snapshot_ResourceStateView_loading() {
        let view = resourceStateView(.loading)
        
        assert(snapshot: view, locale: .en_US, record: record)
        assert(snapshot: view, locale: .ru_RU, record: record)
    }
    
    func test_snapshot_ResourceStateView_error() {
        let view = resourceStateView(.error(anyError()))
        
        assert(snapshot: view, locale: .en_US, record: record)
        assert(snapshot: view, locale: .ru_RU, record: record)
    }
    
    func test_snapshot_ResourceStateView_resource() {
        let view = resourceStateView(.resource("This is a real value."))

        // no localization for this  resource state -
        // it's the responsibility of the caller
        assert(snapshot: view, locale: .en_US, record: record)
    }
    
    // MARK: - Helpers
    typealias StringState = ResourceState<String, Error>
    
    let resourceStateView = { (stringState: StringState) in
        NavigationView {
            ResourceStateView(resourceState: stringState) {
                Text($0)
            }
        }
    }
}

//
//  GenericResourceViewTests.swift
//  
//
//  Created by Igor Malyarov on 07.10.2022.
//

import GenericResourceView
import Presentation
import SwiftUI
import XCTest

final class ResourceStateViewTests: XCTestCase {
    let record = false
    
    func test_snapshotLoadableResourceView_loading() {
        let view = loadableResourceView(.loading)
        
        assert(snapshot: view, locale: .en_US, record: record)
        assert(snapshot: view, locale: .ru_RU, record: record)
    }
    
    func test_snapshotLoadableResourceView_error() {
        let view = loadableResourceView(.error(anyError()))
        
        assert(snapshot: view, locale: .en_US, record: record)
        assert(snapshot: view, locale: .ru_RU, record: record)
    }
    
    func test_snapshotLoadableResourceView_resource() {
        let view = loadableResourceView(.resource("This is a real value."))

        // no localization for this  resource state -
        // it's the responsibility of the caller
        assert(snapshot: view, locale: .en_US, record: record)
    }
    
    // MARK: - Helpers
    typealias StringState = ResourceState<String, Error>
    
    let loadableResourceView = { (stringState: StringState) in
        NavigationView {
            ResourceStateView(resourceState: stringState) {
                Text($0)
            }
        }
    }
}

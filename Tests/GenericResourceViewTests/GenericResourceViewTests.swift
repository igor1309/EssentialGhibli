//
//  GenericResourceViewTests.swift
//  
//
//  Created by Igor Malyarov on 07.10.2022.
//

import GenericResourceView
import SnapshotTesting
import SwiftUI
import XCTest

final class GenericResourceViewTests: XCTestCase {
    let record = false
    
    func test_snapshotLoadableResourceView_loading() {
        let view = loadableResourceView(.loading)
        
        assert(snapshot: view, locale: .en_US, record: record)
        assert(snapshot: view, locale: .ru_RU, record: record)
    }
    
//    func test_snapshotLoadableResourceView_list() {
//        let view = ghibliListView(.list([.castleInTheSky, .kikisDeliveryService]))
//        
//        assert(snapshot: view, locale: .en_US, record: record)
//        assert(snapshot: view, locale: .ru_RU, record: record)
//    }
    
    func test_snapshotLoadableResourceView_error() {
        let view = loadableResourceView(.error(anyError()))
        
        assert(snapshot: view, locale: .en_US, record: record)
        assert(snapshot: view, locale: .ru_RU, record: record)
    }
    
    // MARK: - Helpers
    typealias StringState = ResourceState<String, Error>
    
    let loadableResourceView = { (stringState: StringState) in
        NavigationView {
            LoadableResourceView(resourceState: stringState) {
                Text($0)
            }
        }
    }
}

extension Locale {
    static let en_US: Self = .init(identifier: "en-US")
    static let ru_RU: Self = .init(identifier: "ru-RU")
}

func anyError(message: String = "any error") -> AnyError {
    .init(message: message)
}

struct AnyError: Error {
    let message: String
}

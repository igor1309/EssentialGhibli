//
//  GhibliDetailFeatureTests.swift
//  
//
//  Created by Igor Malyarov on 06.10.2022.
//

import GhibliDetailFeature
import SwiftUI
import XCTest

final class GhibliDetailFeatureTests: XCTestCase {
    let record = false
    
    func test_snapshotGhibliListView_loading() {
        let view = GhibliFilmDetail(detailState: .loading)
        
        assert(snapshot: view, locale: .en_US, record: record)
        assert(snapshot: view, locale: .ru_RU, record: record)
    }
    
    func test_snapshotGhibliListView_detail() {
        let view = GhibliFilmDetail(detailState: .detail(.castleInTheSky))
        
        assert(snapshot: view, locale: .en_US, record: record)
        assert(snapshot: view, locale: .ru_RU, record: record)
    }
    
    func test_snapshotGhibliListView_error() {
        let view = GhibliFilmDetail(detailState: .error(APIError()))
        
        assert(snapshot: view, locale: .en_US, record: record)
        assert(snapshot: view, locale: .ru_RU, record: record)
    }
}

private extension Locale {
    static let en_US: Self = .init(identifier: "en-US")
    static let ru_RU: Self = .init(identifier: "ru-RU")
}

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
    
    func test_snapshotGhibliDetailView() {
        let view = GhibliDetailView(film: .castleInTheSky)
        
        assert(snapshot: view, locale: .en_US, record: record)
    }
}

private extension Locale {
    static let en_US: Self = .init(identifier: "en-US")
}

//
//  DetailFeatureSnapshotTests.swift
//  
//
//  Created by Igor Malyarov on 06.10.2022.
//

import DetailFeature
import SwiftUI
import XCTest

final class DetailFeatureSnapshotTests: XCTestCase {
    let record = false
    
    func test_snapshotGhibliDetailView() {
        let view = FilmDetailView(film: .castleInTheSky)
        
        assert(snapshot: view, locale: .en_US, record: record)
    }
}

private extension Locale {
    static let en_US: Self = .init(identifier: "en-US")
}

//
//  FilmDetailViewSnapshotTests.swift
//  
//
//  Created by Igor Malyarov on 06.10.2022.
//

import DetailFeature
import SwiftUI
import XCTest

final class FilmDetailViewSnapshotTests: XCTestCase {
    let record = false
    
    func test_snapshot_FilmDetailView() {
        let view = FilmDetailView(film: .castleInTheSky) { _ in Color.red }
        
        assert(snapshot: view, locale: .en_US, record: record)
    }
}

private extension Locale {
    static let en_US: Self = .init(identifier: "en-US")
}

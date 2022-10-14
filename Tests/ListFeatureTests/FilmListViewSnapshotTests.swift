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
    
    func test_snapshot_FilmListView_emptyList() {
        let view = makeSUT([])
        
        assert(snapshot: view, locale: .en_US, record: record)
        assert(snapshot: view, locale: .ru_RU, record: record)
    }
    
    func test_snapshot_FilmListView_nonEmptylist() {
        let view = makeSUT([.castleInTheSky, .kikisDeliveryService])
        
        assert(snapshot: view, locale: .en_US, record: record)
        assert(snapshot: view, locale: .ru_RU, record: record)
    }
    
    // MARK: - Helpers
    
    func makeSUT(
        _ films: [ListFilm],
        file: StaticString = #file,
        line: UInt = #line
    ) -> some View {
        NavigationView {
            FilmListView(films: films) {
                Text($0.title)
            }
        }
    }
}

private extension Locale {
    static let en_US: Self = .init(identifier: "en-US")
    static let ru_RU: Self = .init(identifier: "ru-RU")
}

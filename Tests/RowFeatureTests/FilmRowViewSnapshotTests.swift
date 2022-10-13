//
//  FilmRowViewSnapshotTests.swift
//  
//
//  Created by Igor Malyarov on 07.10.2022.
//

import RowFeature
import SwiftUI
import XCTest

final class FilmRowViewSnapshotTests: XCTestCase {
    let record = false
    
    func test_snapshotGhibliRow() {
        let items = [RowFilm.castleInTheSky, .kikisDeliveryService]
        let view = List {
            ForEach(items, content: FilmRowView.init)
        }.listStyle(.plain)
        
        assert(snapshot: view, record: record)
    }
}

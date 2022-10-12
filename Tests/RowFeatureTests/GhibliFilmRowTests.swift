//
//  GhibliFilmRowTests.swift
//  
//
//  Created by Igor Malyarov on 07.10.2022.
//

import RowFeature
import SwiftUI
import XCTest

final class GhibliFilmRowTests: XCTestCase {
    let record = false
    
    func test_snapshotGhibliRow() {
        let items = [GhibliRowFilm.castleInTheSky, .kikisDeliveryService]
        let view = List {
            ForEach(items, content: GhibliFilmRowView.init)
        }.listStyle(.plain)
        
        assert(snapshot: view, record: record)
    }
}

//
//  GhibliRowTests.swift
//  
//
//  Created by Igor Malyarov on 07.10.2022.
//

import GhibliRow
import SwiftUI
import XCTest

final class GhibliRowTests: XCTestCase {
    let record = false
    
    func test_snapshotGhibliRow() {
        let items = [GhibliRowItem.castleInTheSky, .kikisDeliveryService]
        let view = List {
            ForEach(items, content: GhibliItemRow.init)
        }.listStyle(.plain)
        
        assert(snapshot: view, record: record)
    }
}

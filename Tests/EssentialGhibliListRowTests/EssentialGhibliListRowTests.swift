//
//  EssentialGhibliListRowTests.swift
//  
//
//  Created by Igor Malyarov on 07.10.2022.
//

import EssentialGhibliListRow
import SwiftUI
import XCTest

final class EssentialGhibliListTests: XCTestCase {
    let record = false
    
    func test_snapshotEssentialGhibliListRow() {
        let items = [GhibliListItem.castleInTheSky, .kikisDeliveryService]
        let view = List {
            ForEach(items, content: GhibliListItemRow.init)
        }.listStyle(.plain)
        
        assert(snapshot: view, record: record)
    }
}

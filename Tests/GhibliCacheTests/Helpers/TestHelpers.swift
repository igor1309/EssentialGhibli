//
//  TestHelpers.swift
//  
//
//  Created by Igor Malyarov on 09.10.2022.
//

import GhibliCache
import Foundation

typealias CachedItems = CachedFeed<CachedItem>

struct TestItem: Equatable {
    let id: UUID
}

extension TestItem: CustomStringConvertible {
    var description: String {
        return "TestItem(\(id.uuidString.prefix(3))...)"
    }
}

struct CachedItem: Equatable {
    let id: UUID
}

extension CachedItem: CustomStringConvertible {
    var description: String {
        return "CachedItem(\(id.uuidString.prefix(3))...)"
    }
}

func uniqueItemFeed() -> (local: [TestItem], cached: [CachedItem]) {
    let testItems = (0...9).map { _ in TestItem(id: .init()) }
    return (testItems, testItems.map(toCached))
}

func toCached(_ testItem: TestItem) -> CachedItem {
    .init(id: testItem.id)
}

func fromCached(_ cachedItem: CachedItem) -> TestItem {
    .init(id: cachedItem.id)
}

func anyError() -> Error {
    AnyError()
}

struct AnyError: Error, Equatable {}

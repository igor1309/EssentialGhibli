//
//  TestHelpers.swift
//  
//
//  Created by Igor Malyarov on 09.10.2022.
//

import GhibliCache
import Foundation

typealias CachedItems = CachedFeed<LocalItem>

struct TestItem: Equatable {
    let id: UUID
}

extension TestItem: CustomStringConvertible {
    var description: String {
        return "TestItem(\(id.uuidString.prefix(3))...)"
    }
}

struct LocalItem: Equatable {
    let id: UUID
}

extension LocalItem: CustomStringConvertible {
    var description: String {
        return "LocalItem(\(id.uuidString.prefix(3))...)"
    }
}

func uniqueItemFeed() -> (testItems: [TestItem], local: [LocalItem]) {
    let testItems = (0...9).map { _ in TestItem(id: .init()) }
    return (testItems, testItems.map(toLocal))
}

func toLocal(_ testItem: TestItem) -> LocalItem {
    .init(id: testItem.id)
}

func fromLocal(_ local: LocalItem) -> TestItem {
    .init(id: local.id)
}

func anyError() -> Error {
    AnyError()
}

struct AnyError: Error, Equatable {}

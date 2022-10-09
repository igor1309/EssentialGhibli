//
//  TestHelpers.swift
//  
//
//  Created by Igor Malyarov on 09.10.2022.
//

import FeedLoader
import Foundation

typealias CachedItems = CachedFeed<TestItem>

struct TestItem: Equatable {
    let id: UUID
}

extension TestItem: CustomStringConvertible {
    var description: String {
        return "TestItem(\(id.uuidString.prefix(3))...)"
    }
}

func uniqueItemFeed() -> [TestItem] {
    (0...9).map { _ in TestItem(id: .init()) }
}

func anyError() -> Error {
    AnyError()
}

struct AnyError: Error, Equatable {}

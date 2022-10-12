//
//  FeedCachePolicyTests.swift
//  
//
//  Created by Igor Malyarov on 09.10.2022.
//

import Cache
import XCTest

final class FeedCachePolicyTests: XCTestCase {
    
    func test_validate_shouldReturnTrueOnNonExpired() {
        let sut = makeSUT()
        let fixedCurrentDate = Date()
        let expirationTimestamp = fixedCurrentDate.minus(maxAgeInDays: sut.maxCacheAgeInDays).adding(seconds: 1)
        
        XCTAssert(sut.validate(expirationTimestamp, against: fixedCurrentDate))
    }
    
    func test_validate_shouldReturnTrueOnExpiration() {
        let sut = makeSUT()
        let fixedCurrentDate = Date()
        let expirationTimestamp = fixedCurrentDate.minus(maxAgeInDays: sut.maxCacheAgeInDays)
        
        XCTAssert(sut.validate(fixedCurrentDate, against: expirationTimestamp))
    }
    
    func test_validate_shouldReturnFalseOnExpired() {
        let sut = makeSUT()
        let fixedCurrentDate = Date()
        let expirationTimestamp = fixedCurrentDate.minus(maxAgeInDays: sut.maxCacheAgeInDays).adding(seconds: -1)
        
        XCTAssertFalse(sut.validate(expirationTimestamp, against: fixedCurrentDate))
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        calendar: Calendar = .gregorian,
        maxCacheAgeInDays: Int = 7,
        file: StaticString = #file,
        line: UInt = #line
    ) -> FeedCachePolicy {
        let sut = FeedCachePolicy(
            calendar: calendar,
            maxCacheAgeInDays: maxCacheAgeInDays
        )
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }
}

extension Date {
    func minus(maxAgeInDays: Int) -> Date {
        return adding(days: -maxAgeInDays)
    }
}

extension Date {
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }

    func adding(
        minutes: Int,
        calendar: Calendar = .gregorian
    ) -> Date {
        return calendar.date(byAdding: .minute, value: minutes, to: self)!
    }

    func adding(
        days: Int,
        calendar: Calendar = .gregorian
    ) -> Date {
        return calendar.date(byAdding: .day, value: days, to: self)!
    }
}

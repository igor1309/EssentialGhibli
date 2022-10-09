//
//  FeedCachePolicy.swift
//  
//
//  Created by Igor Malyarov on 09.10.2022.
//

import Foundation

public final class FeedCachePolicy {
    
    public static let sevenDays: FeedCachePolicy = .init(calendar: .gregorian, maxCacheAgeInDays: 7)
    
    private let calendar: Calendar
    public let maxCacheAgeInDays: Int
    
    public init(
        calendar: Calendar = .gregorian,
        maxCacheAgeInDays: Int = 7
    ) {
        self.calendar = calendar
        self.maxCacheAgeInDays = maxCacheAgeInDays
    }
    
    public func validate(_ timestamp: Date, against date: Date) -> Bool {
        guard let maxCacheAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: timestamp) else {
            return false
        }
        return date < maxCacheAge
    }
    
}

public extension Calendar {
    static let gregorian: Self = .init(identifier: .gregorian)
}


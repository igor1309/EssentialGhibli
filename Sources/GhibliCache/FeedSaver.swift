//
//  FeedSaver.swift
//  
//
//  Created by Igor Malyarov on 12.10.2022.
//

import Foundation

public protocol FeedSaver<Item> {
    associatedtype Item
    
    func save(feed: [Item], timestamp: Date) throws
}


//
//  ListState.swift
//  
//
//  Created by Igor Malyarov on 06.10.2022.
//

import Foundation

public enum ListState<Item, StateError: Error> {
    case loading
    case empty
    case list([Item])
    case error(StateError)
}

extension ListState: Equatable where Item: Equatable, StateError: Equatable {}
extension ListState: Hashable where Item: Hashable, StateError: Hashable {}

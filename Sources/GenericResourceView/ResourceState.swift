//
//  ResourceState.swift
//  
//
//  Created by Igor Malyarov on 07.10.2022.
//

import Foundation

public enum ResourceState<Resource, StateError> {
    case loading
    case detail(Resource)
    case error(StateError)
}

extension ResourceState: Equatable where Resource: Equatable, StateError: Equatable {}
extension ResourceState: Hashable where Resource: Hashable, StateError: Hashable {}


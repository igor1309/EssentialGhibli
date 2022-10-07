//
//  DetailState.swift
//  
//
//  Created by Igor Malyarov on 07.10.2022.
//

import Foundation

public enum DetailState<Detail, StateError> {
    case loading
    case detail(Detail)
    case error(StateError)
}

extension DetailState: Equatable where Detail: Equatable, StateError: Equatable {}
extension DetailState: Hashable where Detail: Hashable, StateError: Hashable {}

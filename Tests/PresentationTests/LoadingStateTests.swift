//
//  LoadingStateTests.swift
//  
//
//  Created by Igor Malyarov on 12.10.2022.
//

import Presentation
import XCTest

final class LoadingStateTests: XCTestCase {

    func test_init_shouldSetIsLoading() {
        let state = LoadingState(isLoading: true)
        
        XCTAssertEqual(state.isLoading, true)
    }

}

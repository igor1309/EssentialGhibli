//
//  XCTestCase+pause.swift
//  
//
//  Created by Igor Malyarov on 12.10.2022.
//

import XCTest

extension XCTestCase {
    
    func pause(
        for interval: TimeInterval = 0.02,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Pause for \(interval)")
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            exp.fulfill()
        }
        wait(for: [exp], timeout: interval + 0.01)
    }
}

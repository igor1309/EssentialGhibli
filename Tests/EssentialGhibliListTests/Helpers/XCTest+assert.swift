//
//  XCTest+assert.swift
//  
//
//  Created by Igor Malyarov on 07.10.2022.
//

import SnapshotTesting
import SwiftUI
import XCTest

extension XCTest {
    func assert<V: View>(
        snapshot view: V,
        as strategies: [Snapshotting<UIViewController, UIImage>] = [.iPhone13Pro_light, .iPhone13Pro_dark],
        record: Bool,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        let controller = UIHostingController(rootView: view)
        
        assertSnapshots(
            matching: controller,
            as: strategies,
            record: false,
            file: file,
            testName: testName,
            line: line
        )
    }
}

extension Snapshotting
where Value == UIViewController, Format == UIImage {
    
    static let iPhone13Pro_light: Self = .image(
        on: .iPhone13Pro,
        traits: .init(userInterfaceStyle: .light)
    )
    static let iPhone13Pro_dark: Self = .image(
        on: .iPhone13Pro,
        traits: .init(userInterfaceStyle: .dark)
    )
}

//
//  EssentialGhibliListTests.swift
//  
//
//  Created by Igor Malyarov on 06.10.2022.
//

//@testable
import EssentialGhibliList
import SnapshotTesting
import SwiftUI
import XCTest

final class EssentialGhibliListTests: XCTestCase {
    
    func test_snapshotGhibliListView_loading() {
        let view = GhibliListView(listState: .loading)
        
        assert(
            snapshot: view,
            as: [.iPhone13Pro_light, .iPhone13Pro_dark],
            record: false
        )
    }
    
    func test_snapshotGhibliListView_empty() {
        let view = GhibliListView(listState: .empty)
        
        assert(
            snapshot: view,
            as: [.iPhone13Pro_light, .iPhone13Pro_dark],
            record: false
        )
    }
    
    func test_snapshotGhibliListView_list() {
        let view = GhibliListView(listState: .list([.castleInTheSky, .kikisDeliveryService]))
        
        assert(
            snapshot: view,
            as: [.iPhone13Pro_light, .iPhone13Pro_dark],
            record: false
        )
    }
    
    func test_snapshotGhibliListView_error() {
        let view = GhibliListView(listState: .error(APIError()))
        
        assert(
            snapshot: view,
            as: [.iPhone13Pro_light, .iPhone13Pro_dark],
            record: false
        )
    }
    
    // MARK: - Helpers
    
    func assert<V: View>(
        snapshot view: V,
        as strategies: [Snapshotting<UIViewController, UIImage>],
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

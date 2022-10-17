//
//  FilmDetailViewSnapshotTests.swift
//  
//
//  Created by Igor Malyarov on 06.10.2022.
//

import DetailFeature
import SwiftUI
import XCTest

final class FilmDetailViewSnapshotTests: XCTestCase {
    let record = false
    
    func test_snapshot_FilmDetailView_red() {
        let sut = makeSUT()
        
        assert(snapshot: sut, locale: .en_US, record: record)
    }
    
    func test_snapshot_FilmDetailView_orange() {
        let sut = makeSUT(color: .orange)
        
        assert(snapshot: sut, locale: .en_US, record: record)
    }
    
    func test_snapshot_FilmDetailView_triangle() {
        let sut = makeSUT {
            Color.cyan
                .aspectRatio(1, contentMode: .fit)
                .overlay {
                    Image(systemName: "exclamationmark.triangle")
                        .resizable()
                        .scaledToFit()
                }
        }
        
        assert(snapshot: sut, locale: .en_US, record: record)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        color: Color = .red,
        file: StaticString = #file,
        line: UInt = #line
    ) -> some View {
        makeSUT(poster: {
            color.aspectRatio(2/3, contentMode: .fit)
        }, file: file, line:  line)
    }
    
    private func makeSUT(
        poster: @escaping () -> some View,
        file: StaticString = #file,
        line: UInt = #line
    ) -> some View {
        let sut = FilmDetailView(film: .castleInTheSky) { _ in poster() }
        
        return sut
    }
}

private extension Locale {
    static let en_US: Self = .init(identifier: "en-US")
}

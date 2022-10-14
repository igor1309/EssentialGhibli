//
//  FilmRowViewSnapshotTests.swift
//  
//
//  Created by Igor Malyarov on 07.10.2022.
//

import RowFeature
import SwiftUI
import XCTest

final class FilmRowViewSnapshotTests: XCTestCase {
    let record = false
    
    func test_snapshot_FilmRowView_red() {
        let sut = makeSUT()
        
        assert(snapshot: sut, record: record)
    }
    
    func test_snapshot_FilmRowView_orange() {
        let sut = makeSUT(color: .orange)
        
        assert(snapshot: sut, record: record)
    }
    
    func test_snapshot_FilmRowView_triangle() {
        let sut = makeSUT {
            Color.cyan
                .overlay {
                    Image(systemName: "exclamationmark.triangle")
                        .resizable()
                        .scaledToFit()
                }
        }
        
        assert(snapshot: sut, record: record)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        color: Color = .red,
        file: StaticString = #file,
        line: UInt = #line
    ) -> some View {
        makeSUT(thumbnail: {
            color.aspectRatio(1, contentMode: .fit)
        }, file: file, line:  line)
    }
    
    private func makeSUT(
        thumbnail: @escaping () -> some View,
        file: StaticString = #file,
        line: UInt = #line
    ) -> some View {
        let items = [RowFilm.castleInTheSky, .kikisDeliveryService]
        
        func filmRowView(item: RowFilm) -> some View {
            FilmRowView(rowFilm: item) { _ in thumbnail() }
        }
        
        let sut = List {
            ForEach(items, content: filmRowView)
        }.listStyle(.plain)
        
        return sut
    }
}

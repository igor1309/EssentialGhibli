//
//  FeedStoreSpecs.swift
//  
//
//  Created by Igor Malyarov on 10.10.2022.
//

import Foundation

protocol FeedStoreSpecs {
    func test_retrieve_shouldDeliverEmptyOnEmptyCache() throws
    func test_retrieve_shouldHaveNoSideEffectsOnEmptyCache() throws
    func test_retrieve_shouldDeliverInsertedValues() throws
    func test_retrieve_shouldHaveNoSideEffectsOnNonEmptyCache() throws

    func test_insert_shouldDeliverNoErrorOnEmptyCache() throws
    func test_insert_shouldDeliverNoErrorOnNonEmptyCache() throws
    func test_insert_shouldOverridePreviouslyInsertedCache() throws

    func test_delete_shouldHaveNoSideEffectsOnEmptyCache() throws
    func test_delete_shouldEmptyPreviouslyInsertedCache() throws
}

protocol FailableRetrieveFeedStoreSpecs: FeedStoreSpecs {
    func test_retrieve_shouldDeliverErrorOnRetrievalFailure() throws
    func test_retrieve_shouldHaveNoSideEffectsOnRetrievalFailure() throws
}

protocol FailableInsertFeedStoreSpecs: FeedStoreSpecs {
    func test_insert_shouldDeliverErrorOnInsertionFailure() throws
    func test_insert_shouldHaveNoSideEffectsOnInsertionFailure() throws
}

protocol FailableDeleteFeedStoreSpecs: FeedStoreSpecs {
    func test_delete_shouldDeliverErrorOnDeletionFailure() throws
    func test_delete_shouldHaveNoSideEffectsOnDeletionFailure() throws
}

typealias FailableFeedStore = FailableRetrieveFeedStoreSpecs & FailableInsertFeedStoreSpecs & FailableDeleteFeedStoreSpecs

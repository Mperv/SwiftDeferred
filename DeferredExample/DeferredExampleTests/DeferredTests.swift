//
//  DeferredTests.swift
//  DeferredExampleTests
//
//  Created by Mark Pervovskiy on 16/06/15.
//  Copyright (c) 2015 Mark Pervovskiy. All rights reserved.
//

import UIKit
import XCTest

class DeferredTests: XCTestCase {

    var callbackResult: Int = 0
    var errbackResult: Int = 0
    var alwaysResult: Int = 0

    override func setUp() {
        super.setUp()
        callbackResult = 0
        errbackResult = 0
        alwaysResult = 0
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func createSyncDefereedMutithreaded(count: Int) -> Deferred<Int> {
        let deferred = Deferred<Int>()

        deferred.addSyncAlways {
            self.alwaysResult += 50
        }

        let group: dispatch_group_t = dispatch_group_create()

        for (var i: Int = 0; i < count; i++) {
            let a = i
            dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                deferred.addSyncCallback {
                    (value: Int) in
                    self.callbackResult += a + value
                }
            }
            dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                deferred.addSyncErrback {
                    (e: NSError) in
                    self.errbackResult += a
                }
            }
        }

        dispatch_group_wait(group, DISPATCH_TIME_FOREVER)

        deferred.addSyncAlways {
            self.alwaysResult += 50
        }

        return deferred
    }

    func testMultithreadedCallbackCreation() {
        let count = 50
        let deferred: Deferred<Int> = createSyncDefereedMutithreaded(count)

        XCTAssert(!deferred.state.fulfilled)
        XCTAssert(!deferred.state.resolved)

        let value = 10
        deferred.fulfill(value)
        // Once fulfilled deferred should stay in fulfilled state, so next three line should not affect anything
        deferred.reject(NSError(domain: "", code: 0, userInfo: nil))
        deferred.fulfill(value)
        deferred.reject(NSError(domain: "", code: 0, userInfo: nil))

        XCTAssertEqual(callbackResult, count * value + (count * (count - 1)) / 2)
        XCTAssertEqual(alwaysResult, 100)
        XCTAssertEqual(errbackResult, 0)

        XCTAssert(deferred.state.fulfilled)
        XCTAssert(deferred.state.resolved)
    }

    func testMultithreadedErrbackCreation() {
        let count = 50
        let deferred: Deferred<Int> = createSyncDefereedMutithreaded(count)

        XCTAssert(!deferred.state.fulfilled)
        XCTAssert(!deferred.state.resolved)

        deferred.reject(NSError(domain: "", code: 0, userInfo: nil))
        // Once rejected deferred should stay in rejected state, so next three line should not affect anything
        deferred.fulfill(10)
        deferred.reject(NSError(domain: "", code: 0, userInfo: nil))
        deferred.fulfill(10)

        XCTAssertEqual(callbackResult, 0)
        XCTAssertEqual(alwaysResult, 100)
        XCTAssertEqual(errbackResult, (count * (count - 1)) / 2)

        XCTAssert(!deferred.state.fulfilled)
        XCTAssert(deferred.state.resolved)
    }

    func testChainExecution() {
        let test: String = "Let's test using some text!"
        let deferred = Deferred<String>()
        var chained = deferred

        for c: Character in test.characters {
            chained = chained.chain(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                (s: String) -> ChainResult<String> in
                return ChainResult(s + String(c))
            }
        }
        let semaphore: dispatch_semaphore_t = dispatch_semaphore_create(0)
        chained.addSyncCallback {
            (s: String) -> Void in
            dispatch_semaphore_signal(semaphore)
        }
        deferred.fulfill("")
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)

        XCTAssert(chained.state.fulfilled)
        XCTAssertEqual(chained.state.value!, test)
    }
}

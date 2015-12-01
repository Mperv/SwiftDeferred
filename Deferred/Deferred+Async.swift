//
//  Deferred+Async.swift
//  DeferredExample
//
//  Created by Mark Pervovskiy on 17/11/14.
//  Copyright (c) 2014 Mark Pervovskiy. All rights reserved.
//

import Foundation

extension Deferred {

    /*
    Adds asyncronous callback that executes in provided queue.
    */
    public func addCallback(queue: dispatch_queue_t, callback: (T) -> Void) -> Deferred<T> {
        return addSyncCallback {
            (value: T) -> Void in
            dispatch_async(queue) {
                callback(value)
            }
        }
    }

    /*
    Adds asyncronous callback that executes in main queue.
    */
    public func addCallback(callback: (T) -> Void) -> Deferred<T> {
        return addCallback(dispatch_get_main_queue(), callback: callback)
    }

    /*
    Adds asyncronous errback that executes in provided queue.
    */
    public func addErrback(queue: dispatch_queue_t, errback: (NSError) -> Void) -> Deferred<T> {
        return addSyncErrback {
            (error: NSError) -> Void in
            dispatch_async(queue) {
                errback(error)
            }
        }
    }

    /*
    Adds asyncronous errback that executes in main queue.
    */
    public func addErrback(errback: (NSError) -> Void) -> Deferred<T> {
        return addErrback(dispatch_get_main_queue(), errback: errback)
    }

    /*
    Adds asyncronous 'always' function that executes in provided queue.
    */
    public func addAlways(queue: dispatch_queue_t, always: Void -> Void) -> Deferred<T> {
        return addSyncAlways {
            Void -> Void in
            dispatch_async(queue) {
                always()
            }
        }
    }

    /*
    Adds asyncronous 'always' function that executes in main queue.
    */
    public func addAlways(always: Void -> Void) -> Deferred<T> {
        return addAlways(dispatch_get_main_queue(), always: always)
    }

    /*
    Creates new Deferred. When chained Deferred fulfills 'transform' function is executed.
    The result of 'transform' function resolves new Deferred.
    'transform' function executes in provided queue.
    */
    public func chain<TOut>(queue: dispatch_queue_t, transform: (Deferred<TOut>, T) -> Void) -> Deferred<TOut> {
        let newDeferred = Deferred<TOut>()
        addCallback(queue) {
            (value: T) -> Void in
            transform(newDeferred, value)
        }
        addErrback(queue) {
            (error: NSError) -> Void in
            newDeferred.reject(error)
        }
        return newDeferred
    }

    /*
    Creates new Deferred. When chained Deferred fulfills 'transform' function is executed.
    The result of 'transform' function resolves new Deferred.
    'transform' function executes in main queue.
    */
    public func chain<TOut>(transform: (Deferred<TOut>, T) -> Void) -> Deferred<TOut> {
        return chain(dispatch_get_main_queue(), transform: transform)
    }

    /*
    Creates new Deferred. When chained Deferred fulfills 'transform' function is executed.
    The result of 'transform' function resolves new Deferred.
    'transform' function executes in provided queue.
    */
    public func chain<TOut>(queue: dispatch_queue_t, transform: (T) -> (ChainResult<TOut>)) -> Deferred<TOut> {
        return chain(queue) {
            (newDeferred: Deferred<TOut>, value: T) -> Void in
            let result: ChainResult<TOut> = transform(value)
            switch result {
            case .Fulfilment(let resultValue):
                newDeferred.fulfill(resultValue.boxed)
            case .Error(let error):
                newDeferred.reject(error)
            }
        }
    }

    /*
    Creates new Deferred. When chained Deferred fulfills 'transform' function is executed.
    The result of 'transform' function resolves new Deferred.
    'transform' function executes in main queue.
    */
    public func chain<TOut>(transform: (T) -> (ChainResult<TOut>)) -> Deferred<TOut> {
        return chain(dispatch_get_main_queue(), transform: transform)
    }

}

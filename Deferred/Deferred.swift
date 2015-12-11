//
//  Deferred.swift
//  PromisesExperiment
//
//  Created by Mark Pervovskiy on 09/11/14.
//  Copyright (c) 2014 Mark Pervovskiy. All rights reserved.
//

import Foundation

/*
Type-safe, thread-safe and chainable Swift implementation of Deferred. Deferred represents work that is not finished.
Deferred can be in three states:
    - None: work in progress
    - Fulfilled: work is finished successfully, result is available
    - Rejected: work is finished unsuccessfully, error is available
Once resolved (either fulfilled or rejected) Deferred should be unable to change its state.
*/

public class Deferred<T> {
    private var _lock: NSLock = NSLock()

    private var _callbacks: [(T) -> Void] = []
    private var _errbacks: [(NSError) -> Void] = []

    private var _state: DeferredState<T>
    public var state: DeferredState<T> { return _state }

    public init() {
        _state = .None
    }

    /*
    Adds callback. It will be executed if Deferred fulfills.
    Note: Callback executes on the same thread as 'fulfill'. 'fulfill' returns only when all callbacks has been executed.
    */
    public func addSyncCallback(callback: (T) -> Void) -> Deferred<T> {
        _lock.lock()
        switch _state {
        case .None:
            _callbacks.append(callback)
            _lock.unlock()
        case .Fulfilled(let value):
            _lock.unlock()
            callback(value.boxed)
        case .Rejected(_ ):
            _lock.unlock()
        }
        return self
    }

    /*
    Adds errback. It will be executed if Deferred rejects.
    Note: Errback executes on the same thread as 'reject'. 'reject' returns only when all errbacks has been executed.
    */
    public func addSyncErrback(errback: (NSError) -> Void) -> Deferred<T> {
        _lock.lock()
        switch _state {
        case .None:
            _errbacks.append(errback)
            _lock.unlock()
        case .Fulfilled(_ ):
            _lock.unlock()
        case .Rejected(let error):
            _lock.unlock()
            errback(error)
        }
        return self
    }

    /*
    Adds 'always' function. It will be executed if Deferred resolves (either by 'fulfill' or by 'reject').
    Note: 'always' function executes on the same thread as 'fulfill' or 'reject'. 'fulfill' or 'reject' returns only when all 'always' functions has been executed.
    */
    public func addSyncAlways(always: Void -> Void) -> Deferred<T> {
        addSyncCallback {
            (result: T) -> Void in
            always()
        }
        addSyncErrback {
            (error: NSError) -> Void in
            always()
        }
        return self
    }

    /*
    Resolves Deferred by setting Fulfilled status and fulfilment value. All added callbacks execute here also.
    */
    public func fulfill(value: T) {
        _lock.lock()
        if (_state.resolved) {
            _lock.unlock()
            return
        }
        _state = .Fulfilled(Box(value))
        _lock.unlock()

        for callback in _callbacks {
            callback(value)
        }
    }

    /*
    Resolves Deferred by setting Rejected status and error. All added errbacks execute here also.
    */
    public func reject(error: NSError) {
        _lock.lock()
        if (_state.resolved) {
            _lock.unlock()
            return
        }
        _state = .Rejected(error)
        _lock.unlock()

        for errback in _errbacks {
            errback(error)
        }
    }
}


//
//  Deferred.swift
//  PromisesExperiment
//
//  Created by Mark Pervovskiy on 09/11/14.
//  Copyright (c) 2014 Mark Pervovskiy. All rights reserved.
//

import Foundation


public class Deferred<T> {
    private var _lock: NSLock = NSLock();
    
    private var _callbacks: Array<(T)->Void> = Array<(T)->Void>();
    private var _errbacks: Array<(NSError)->Void> = Array<(NSError)->Void>();

    private var _state : DeferredState;
    public var state: DeferredState { get {return _state; }}
    
    private var _value: T?;
    public var value: T {get { return _value!; }}
  
    private var _error: NSError? = nil;
    public var error: NSError {get { return _error!; }}
    
    public init(){
        _state = .None
    }
    
    public func addSyncCallback(callback: (T)->Void) -> Deferred<T> {
        _lock.lock();
        if _state == .None {
            _callbacks.append(callback);
        }
        if _state == .Fulfilment {
            _lock.unlock();
            callback(_value!);
        } else {
            _lock.unlock();
        }
        return self;
    }

    public func addSyncErrback(errback: (NSError)->Void) -> Deferred<T> {
        _lock.lock();
        if _state == .None {
            _errbacks.append(errback);
        }
        if _state == .Error {
            _lock.unlock();
            errback(_error!);
        } else {
            _lock.unlock();
        }
        return self;
    }

    public func addSyncAlways(always: Void->Void) -> Deferred<T> {
        addSyncCallback {(result:T)->Void in always()}
        addSyncErrback {(error:NSError)->Void in always()}
        return self;
    }
       
    public func resolve(value: T) {
        _lock.lock();
        if (_state != .None) {
            _lock.unlock();
            return;
        }
        _state = .Fulfilment
        _value = value
        _lock.unlock();
        
        for callback in _callbacks {
            callback(value);
        }
    }

    public func reject(error: NSError) {
        _lock.lock();
        if (_state != .None) {
            _lock.unlock();
            return;
        }
        _state = .Error
        _error = error;
        _lock.unlock();
        
        for errback in _errbacks {
            errback(error);
        }
    }
}


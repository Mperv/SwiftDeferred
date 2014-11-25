//
//  Deferred+Async.swift
//  DeferredExample
//
//  Created by Mark Pervovskiy on 17/11/14.
//  Copyright (c) 2014 Mark Pervovskiy. All rights reserved.
//

import Foundation

extension Deferred{
    
    public func addCallback(queue: dispatch_queue_t = dispatch_get_main_queue()
        , callback: (T)->Void) -> Deferred<T> {
        return addSyncCallback {(value:T) -> Void in
            dispatch_async(queue) {
                callback(value);
            };
        }
    }
    
    public func addErrback(queue: dispatch_queue_t = dispatch_get_main_queue()
        , errback: (NSError)->Void) -> Deferred<T> {
        return addSyncErrback {(error: NSError) -> Void in
            dispatch_async(queue) {
                errback(error);
            };
        }
    }
    
    public func addAlways(queue: dispatch_queue_t = dispatch_get_main_queue()
        , always: Void->Void) -> Deferred<T> {
        return addSyncAlways {Void -> Void in
            dispatch_async(queue) {
                always();
            };
        }
    }
    
    public func chain<TOut>(queue: dispatch_queue_t = dispatch_get_main_queue()
        , transform: (Deferred<TOut>, T)->Void) -> Deferred<TOut> {
            var newDeferred = Deferred<TOut>();
            addCallback(queue: queue) {(value: T)->Void in
                transform(newDeferred, value);
            };
            addErrback(queue: queue) {(error: NSError)->Void in newDeferred.reject(error)}
            
            return newDeferred;
    }
    
    public func chain<TOut>(queue: dispatch_queue_t = dispatch_get_main_queue()
        , transform: (T)->(EnqueueResult<TOut>)) -> Deferred<TOut> {
        return chain(queue: queue) { (newDeferred: Deferred<TOut>, value: T)->Void in
            let result: EnqueueResult<TOut> = transform(value);
            if (result.fulfiled) {
                newDeferred.resolve(result.value);
            } else {
                newDeferred.reject(result.error);
            }
        }
    }
    
}

//
//  Deferred+NSURLRequest.swift
//  DeferredExample
//
//  Created by Mark Pervovskiy on 17/11/14.
//  Copyright (c) 2014 Mark Pervovskiy. All rights reserved.
//

import Foundation

extension Deferred {

    public func chainRequest(queue: dispatch_queue_t, transform: (T) -> (NSURLRequest)) -> Deferred<(NSURLResponse, NSData)> {

        return chain(queue) {
            (newDeferred: Deferred<(NSURLResponse, NSData)>, value: T) -> Void in
            let request: NSURLRequest = transform(value)
            NSURLConnection.sendAsynchronousRequest(request
                    , queue: NSOperationQueue.mainQueue()
                    , completionHandler: {
                (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                if (data != nil) {
                    newDeferred.fulfill(response!, data!)
                } else {
                    newDeferred.reject(error)
                }
            })
        }
    }

    public func chainRequest(transform: (T) -> (NSURLRequest)) -> Deferred<(NSURLResponse, NSData)> {
        return chainRequest(dispatch_get_main_queue(), transform: transform)
    }
}

//
//  NSURLRequest+Deferred.swift
//  DeferredExample
//
//  Created by Mark Pervovskiy on 16/06/15.
//  Copyright (c) 2015 Mark Pervovskiy. All rights reserved.
//

import Foundation

extension NSURLRequest {
    public func deferred() -> Deferred<(NSURLResponse, NSData)> {
        let deferred = Deferred<(NSURLResponse, NSData)>()
        NSURLConnection.sendAsynchronousRequest(self
                , queue: NSOperationQueue.mainQueue()
                , completionHandler: {
            (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            if (data != nil) {
                deferred.fulfill(response!, data!)
            } else {
                deferred.reject(error!)
            }
        })
        return deferred
    }
}

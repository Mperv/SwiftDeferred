//
//  Deferred+NSURLRequest.swift
//  DeferredExample
//
//  Created by Mark Pervovskiy on 17/11/14.
//  Copyright (c) 2014 Mark Pervovskiy. All rights reserved.
//

import Foundation

extension Deferred{
    
    public func chain(queue: dispatch_queue_t = dispatch_get_main_queue(), transform: (T)->(NSURLRequest)) -> Deferred<(NSURLResponse, NSData)> {
        
        return chain(queue: queue) { (newDeferred: Deferred<(NSURLResponse, NSData)>, value: T)->Void in
            let request: NSURLRequest = transform(value);
            NSURLConnection.sendAsynchronousRequest(request
                , queue: NSOperationQueue.mainQueue()
                , completionHandler: {(response: NSURLResponse!, data: NSData!, error: NSError!)->Void in
                    if (data != nil) {
                        newDeferred.resolve(response!, data!)
                    } else {
                        newDeferred.reject(error)
                    }
            });
        }
    }
    
}

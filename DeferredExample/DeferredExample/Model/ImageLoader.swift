//
//  ImageLoader.swift
//  DeferredExample
//
//  Created by Mark Pervovskiy on 16/06/15.
//  Copyright (c) 2015 Mark Pervovskiy. All rights reserved.
//

import UIKit

public class ImageLoader {

    public class func loadImage(url: String, size: CGSize) -> Deferred<UIImage> {

        let nsurl: NSURL? = NSURL(string: url)
        let request: NSURLRequest = NSURLRequest(URL: nsurl!)
        let deferred: Deferred<UIImage> = request

        .deferred()

        .chain(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            (response: NSURLResponse, data: NSData) -> ChainResult<UIImage> in

            if let img = ImageHelpers.createImage(data, cellSize: size) {
                return ChainResult(img)
            }
            let details: [NSObject:AnyObject] = [NSLocalizedDescriptionKey: "Unable to create image from \(url)", ErrorConstants.errorUrlKey: url]
            return ChainResult(NSError(domain: ErrorConstants.errorExampleDomain, code: ErrorConstants.errorBadUrlCode, userInfo: details))
        }

        return deferred
    }

}

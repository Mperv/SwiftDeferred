//
//  CollectionViewCell.swift
//  DeferredExample
//
//  Created by Mark Pervovskiy on 20/11/14.
//  Copyright (c) 2014 Mark Pervovskiy. All rights reserved.
//

import UIKit

public class CollectionViewCell: UICollectionViewCell {
    @IBOutlet var _imageView: UIImageView!
    @IBOutlet var _activityIndicatorView: UIActivityIndicatorView!;
    private var _url:String = "";
    
    private class func resizeImage(image: UIImage,_ newSize: CGSize)-> UIImage {
        // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
        // Pass 1.0 to force exact pixel size.
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height));
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    }
    
    private func calcSmallImageSize(image: UIImage) -> CGSize {
        let cellSize = CGSizeMake(self.frame.width, self.frame.height);
        let oldSize: CGSize = image.size;
        var newWidth = cellSize.width;
        var newHeight = (cellSize.width / oldSize.width) * oldSize.height;
        if newHeight<=cellSize.height {
            return CGSizeMake(newWidth, newHeight);
        }
        newHeight = cellSize.height;
        newWidth = (cellSize.height / oldSize.height) * oldSize.width;
        
        return CGSizeMake(newWidth, newHeight);
    }
    
    public func setup(url: String){
        _imageView.hidden = true;
        _url = url;
        self.backgroundColor = UIColor.clearColor();

        let deferred2 = Deferred<Void>();
        deferred2
            .chain {[unowned self] (value:Void) -> EnqueueResult<Void> in
                self._activityIndicatorView.hidden = false;
                self._activityIndicatorView.startAnimating();
                return EnqueueResult();
            }
            .chainRequest {[unowned self] value -> NSURLRequest in
                let url:NSURL? = NSURL(string: url)
                let request:NSURLRequest = NSURLRequest(URL: url!);
                return request;
            }
            .chain (queue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {[unowned self] (response: NSURLResponse, data: NSData) -> EnqueueResult<UIImage> in
                if let img = UIImage(data:data) {
                    let newImage = CollectionViewCell.resizeImage(img, self.calcSmallImageSize(img));
                    return EnqueueResult(newImage);
                }
                var details: Dictionary = Dictionary(dictionaryLiteral: (NSLocalizedDescriptionKey, "Unable to create image from \(url)"), ("ru.mperv.url.Key", url));
                return EnqueueResult(error: NSError(domain: "ru.mperv.DeferredExample.ErrorDomain", code: 1, userInfo: details));
            }
            .addErrback {[weak self] (error:NSError) -> Void in
                // check if cell already used to show another image
                if (self == nil) || (self!._url != url) { return; }
                
                self!.backgroundColor = UIColor(red: 0.7, green: 0.1, blue: 0.2, alpha: 0.3);
            }
            .addCallback {[weak self] (image: UIImage) -> Void in
                // check if cell already used to show another image
                if (self == nil) || (self!._url != url) { return; }
                
                self!._imageView.image = image;
                self!._imageView.hidden = false;
            }
            .addAlways {
                // check if cell already used to show another image
                if (self._url != url) { return; }
                
                self._activityIndicatorView.hidden = true;
        }
        deferred2.resolve();
    }
}
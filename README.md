SwiftDeferred
=============
Usage:

        let deferred = Deferred<Int>();
        deferred
            .chain {EnqueueResult($0+10)}
            .chain {EnqueueResult($0+100)}
            .chain {value->EnqueueResult<Int> in
                println(value);
                return EnqueueResult(value+100);
            }
            .chain {value->EnqueueResult<Void> in
                println(value);
                return EnqueueResult()
        }
        deferred.resolve(1);
        
or
        
        let deferred2 = Deferred<Void>();
        deferred2
            .chain {[unowned self] (value:Void) -> EnqueueResult<Void> in
                self._activityIndicatorView.hidden = false;
                self._activityIndicatorView.startAnimating();
                return EnqueueResult();
            }
            .chain {[unowned self] value -> NSURLRequest in
                let url:NSURL? = NSURL(string: url)
                let request:NSURLRequest = NSURLRequest(URL: url!);
                return request;
            }
            .chain (queue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {[unowned self] (response: NSURLResponse, data: NSData) -> EnqueueResult<UIImage> in
                let img = UIImage(data:data);
                if (img == nil) {
                    var details: Dictionary = Dictionary(dictionaryLiteral:
                        (NSLocalizedDescriptionKey, "Unable to create image from "+url)
                        , ("ru.mperv.url.Key", url));
                    return EnqueueResult(error: NSError(domain: "ru.mperv.DeferredExample.ErrorDomain"
                        , code: 1, userInfo: details));
                }
                let newImage = CollectionViewCell.resizeImage(img!, self.calcSmallImageSize(img!));
                return EnqueueResult(newImage);
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

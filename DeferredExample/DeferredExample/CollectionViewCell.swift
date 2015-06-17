//
//  CollectionViewCell.swift
//  DeferredExample
//
//  Created by Mark Pervovskiy on 20/11/14.
//  Copyright (c) 2014 Mark Pervovskiy. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    let _imageView: UIImageView
    let _activityIndicatorView: UIActivityIndicatorView

    private var _url: String = ""
    private var _deferred: Deferred<UIImage> = Deferred<UIImage>()

    private static let errorCellBGColor = UIColor(red: 0.7, green: 0.1, blue: 0.2, alpha: 0.3)

    override init(frame: CGRect) {
        _imageView = UIImageView()
        _activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .White)

        super.init(frame: frame)

        _imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.contentView.addSubview(_imageView)

        _activityIndicatorView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.contentView.addSubview(_activityIndicatorView)


        let viewsDictionary: [String:AnyObject] = ["image": _imageView]

        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[image]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[image]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary))

        self.contentView.addConstraint(NSLayoutConstraint(item: _activityIndicatorView, attribute: .CenterX, relatedBy: .Equal
                , toItem: self.contentView, attribute: .CenterX, multiplier: 1, constant: 0))
        self.contentView.addConstraint(NSLayoutConstraint(item: _activityIndicatorView, attribute: .CenterY, relatedBy: .Equal
                , toItem: self.contentView, attribute: .CenterY, multiplier: 1, constant: 0))
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(url: String) {
        _url = url

        backgroundColor = UIColor.clearColor()
        _imageView.hidden = true
        _activityIndicatorView.hidden = false
        _activityIndicatorView.startAnimating()

        _deferred = ImageLoader.loadImage(url, size: frame.size)
        _deferred
        .addErrback {
            [weak self] (error: NSError) -> Void in

            // check if cell already used to show another image
            if (self == nil) || (self!._url != url) { return }

            self!.backgroundColor = CollectionViewCell.errorCellBGColor
        }

        .addCallback {
            [weak self] (image: UIImage) -> Void in

            // check if cell already used to show another image
            if (self == nil) || (self!._url != url) { return }

            self!._imageView.image = image
            self!._imageView.hidden = false
        }

        .addAlways {
            [weak self] in

            // check if cell already used to show another image
            if (self == nil) || (self!._url != url) { return }

            self!._activityIndicatorView.hidden = true
        }
    }
}
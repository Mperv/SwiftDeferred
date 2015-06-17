//
//  ImageHelpers.swift
//  DeferredExample
//
//  Created by Mark Pervovskiy on 16/06/15.
//  Copyright (c) 2015 Mark Pervovskiy. All rights reserved.
//

import UIKit

public class ImageHelpers {

    public class func resizeImage(image: UIImage, newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    private class func calcSmallImageSize(image: UIImage, cellSize: CGSize) -> CGSize {
        let oldSize: CGSize = image.size
        var newWidth: CGFloat = cellSize.width
        var newHeight: CGFloat = (cellSize.width / oldSize.width) * oldSize.height
        if newHeight <= cellSize.height {
            return CGSizeMake(newWidth, newHeight)
        }
        newHeight = cellSize.height
        newWidth = (cellSize.height / oldSize.height) * oldSize.width

        return CGSizeMake(newWidth, newHeight)
    }

    public class func createImage(data: NSData, cellSize: CGSize) -> UIImage? {
        if let img = UIImage(data: data) {
            let imageSize: CGSize = calcSmallImageSize(img, cellSize: cellSize)
            let newImage: UIImage = resizeImage(img, newSize: imageSize)
            return newImage
        }
        return nil
    }
}

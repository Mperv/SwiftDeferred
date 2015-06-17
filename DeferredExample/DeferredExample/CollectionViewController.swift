//
//  CollectionViewController.swift
//  DeferredExample
//
//  Created by Mark Pervovskiy on 20/11/14.
//  Copyright (c) 2014 Mark Pervovskiy. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {

    private let _reuseIdentifier = "COLLECTION_VIEW_CONTROLLER_PHOTO_CELL"
    private let _list: StringArrayViewer

    init(collectionViewLayout layout: UICollectionViewLayout, list: StringArrayViewer) {
        _list = list
        super.init(collectionViewLayout: layout)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        collectionView!.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: _reuseIdentifier)
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _list.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell: CollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(_reuseIdentifier, forIndexPath: indexPath) as! CollectionViewCell
        cell.setup(_list[indexPath.row])
        return cell
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(151, 151)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(1, 1, 1, 1)
    }

}
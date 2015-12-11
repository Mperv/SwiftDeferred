//
//  Box.swift
//  DeferredExample
//
//  Created by Mark Pervovskiy on 16/06/15.
//  Copyright (c) 2015 Mark Pervovskiy. All rights reserved.
//

import Foundation

/*
Since generic enums are not fully supported in Swift we need to box generic type values.
http://stackoverflow.com/questions/27257522/whats-the-exact-limitation-on-generic-associated-values-in-swift-enums
*/

public final class Box<T> {
    private let _boxed: T
    public var boxed: T { get { return _boxed } }

    public init(_ value: T) {
        _boxed = value
    }
}
